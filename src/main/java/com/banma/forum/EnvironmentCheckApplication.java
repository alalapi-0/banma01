package com.banma.forum; // 定义主程序所在的包，便于被 Maven 编译

import java.io.BufferedReader; // 用于读取子进程输出
import java.io.File; // 用于检查环境变量路径
import java.io.IOException; // 捕获 IO 操作异常
import java.io.InputStreamReader; // 将字节流转换为字符流
import java.net.HttpURLConnection; // 用于执行网络连通性检测
import java.net.URL; // 网络检测所需的 URL 类型
import java.nio.charset.StandardCharsets; // 指定读取进程输出时的字符集
import java.util.ArrayList; // 保存所有检测结果
import java.util.List; // List 接口
import java.util.regex.Matcher; // 正则匹配器
import java.util.regex.Pattern; // 正则表达式

/**
 * EnvironmentCheckApplication 是一个独立的主程序，用来对运行论坛项目所需的
 * 本地环境进行快速体检。程序会输出一份人类可读的报告，并在检测失败时返回非零退出码。
 */
public class EnvironmentCheckApplication {
    // 规定最低支持的 Java 与 Comet 版本，可以按需要调整
    private static final String REQUIRED_JAVA_VERSION = "1.8";
    private static final String REQUIRED_COMET_VERSION = "2.0.0";
    private static final String REQUIRED_MAVEN_VERSION = "3.6.0";
    // 网络连通性检测时访问的地址，可根据部署环境替换
    private static final String NETWORK_TEST_URL = "https://www.baidu.com";

    public static void main(String[] args) {
        List<CheckResult> results = new ArrayList<>(); // 存放所有检测结果的列表

        // 逐项执行检测任务
        results.add(checkJavaVersion(REQUIRED_JAVA_VERSION));
        results.add(checkCommandVersion("Comet", REQUIRED_COMET_VERSION, "comet", "--version"));
        results.add(checkNetworkConnectivity(NETWORK_TEST_URL));
        results.add(checkEnvironmentVariable("JAVA_HOME"));
        results.add(checkCommandVersion("Maven 构建工具", REQUIRED_MAVEN_VERSION, "mvn", "-version"));
        results.add(checkJdbcDriver("com.mysql.cj.jdbc.Driver"));

        printReport(results); // 将检测结果输出为报告，方便人工检查

        // 若存在失败项，返回非 0 状态码，便于脚本集成
        boolean hasFailure = results.stream().anyMatch(r -> r.status == Status.FAIL); // 判断是否存在失败项
        if (hasFailure) { // 如果存在失败项
            System.exit(1); // 以非零状态码退出，便于脚本识别错误
        }
    }

    /**
     * 检查当前 JVM 是否满足最低版本要求。
     */
    private static CheckResult checkJavaVersion(String requiredVersion) {
        String current = System.getProperty("java.version"); // 读取 JVM 版本
        if (current == null || current.trim().isEmpty()) {
            return new CheckResult("Java 版本", Status.FAIL, "无法获取当前 Java 版本，请确认 JVM 是否可用");
        }
        if (isVersionAtLeast(current, requiredVersion)) {
            return new CheckResult("Java 版本", Status.PASS,
                    String.format("当前版本 %s，满足最低要求 %s", current, requiredVersion));
        }
        return new CheckResult("Java 版本", Status.FAIL,
                String.format("当前版本 %s 低于最低要求 %s，请升级后重试", current, requiredVersion));
    }

    /**
     * 检查特定命令的版本号，确保满足最低要求。
     */
    private static CheckResult checkCommandVersion(String displayName, String minimumVersion, String... command) {
        ProcessBuilder pb = new ProcessBuilder(command); // 构建执行命令
        pb.redirectErrorStream(true); // 合并标准输出和错误输出，方便统一读取
        try {
            Process process = pb.start(); // 启动命令
            StringBuilder output = new StringBuilder(); // 用于缓存命令输出
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(process.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) { // 逐行读取命令输出
                    output.append(line).append('\n'); // 读取全部输出
                }
            }
            int exitCode = process.waitFor(); // 等待命令执行完成
            if (exitCode != 0) { // 非零退出码代表执行失败
                return new CheckResult(displayName, Status.FAIL,
                        String.format("执行 %s 失败，退出码 %d，输出：%s",
                                command[0], exitCode, output.toString().trim()));
            }
            String version = parseVersionFromOutput(output.toString());
            if (version == null) { // 没有解析到版本号
                return new CheckResult(displayName, Status.WARN,
                        String.format("命令输出无法解析版本号：%s", output.toString().trim()));
            }
            if (minimumVersion == null || isVersionAtLeast(version, minimumVersion)) { // 未设置最低版本或满足要求
                return new CheckResult(displayName, Status.PASS,
                        String.format("检测到版本 %s，满足最低要求 %s", version,
                                minimumVersion == null ? "(未设置)" : minimumVersion));
            }
            return new CheckResult(displayName, Status.FAIL, // 版本过低，提示升级
                    String.format("检测到版本 %s 低于最低要求 %s，请升级", version, minimumVersion));
        } catch (IOException e) { // 命令不存在或执行失败
            return new CheckResult(displayName, Status.FAIL,
                    String.format("未找到命令 %s，请确认已正确安装：%s",
                            command.length > 0 ? command[0] : displayName, e.getMessage()));
        } catch (InterruptedException e) { // 当前线程被中断
            Thread.currentThread().interrupt(); // 重新标记中断状态
            return new CheckResult(displayName, Status.FAIL, "检测过程中被中断，请重新执行");
        }
    }

    /**
     * 检查网络连通性，通过发起一次 HTTP 请求验证对外访问能力。
     */
    private static CheckResult checkNetworkConnectivity(String targetUrl) {
        try {
            HttpURLConnection connection = (HttpURLConnection) new URL(targetUrl).openConnection(); // 构造连接对象
            connection.setConnectTimeout(5000); // 最长等待 5 秒建立连接
            connection.setReadTimeout(5000); // 最长等待 5 秒读取响应
            connection.setRequestMethod("GET");
            connection.connect();
            int code = connection.getResponseCode(); // 获取 HTTP 状态码
            if (code >= 200 && code < 400) { // 200-399 视为访问成功
                return new CheckResult("网络连通性", Status.PASS,
                        String.format("成功访问 %s，HTTP 状态码 %d", targetUrl, code));
            }
            return new CheckResult("网络连通性", Status.FAIL,
                    String.format("访问 %s 返回异常状态码 %d", targetUrl, code));
        } catch (IOException e) { // 发生异常通常是网络不可达或 DNS 失败
            return new CheckResult("网络连通性", Status.FAIL,
                    String.format("无法访问 %s：%s", targetUrl, e.getMessage()));
        }
    }

    /**
     * 检查环境变量是否已经设置以及其指向的路径是否存在。
     */
    private static CheckResult checkEnvironmentVariable(String name) {
        String value = System.getenv(name); // 读取环境变量
        if (value == null || value.trim().isEmpty()) { // 没有配置该环境变量
            return new CheckResult(name + " 环境变量", Status.WARN,
                    "未设置该环境变量，建议配置以保证工具链正常工作");
        }
        File path = new File(value); // 将变量值转成文件路径
        if (path.exists()) { // 路径存在
            return new CheckResult(name + " 环境变量", Status.PASS,
                    String.format("已设置为 %s，路径存在", value));
        }
        return new CheckResult(name + " 环境变量", Status.WARN, // 路径不存在，提醒检查
                String.format("已设置为 %s，但路径不存在，请检查", value));
    }

    /**
     * 检测 JDBC 驱动是否可用，确保项目运行时能够访问数据库。
     */
    private static CheckResult checkJdbcDriver(String driverClass) {
        try {
            Class.forName(driverClass); // 尝试加载驱动类
            return new CheckResult("数据库驱动", Status.PASS,
                    String.format("成功加载 %s，JDBC 驱动可用", driverClass));
        } catch (ClassNotFoundException e) {
            return new CheckResult("数据库驱动", Status.WARN,
                    String.format("未能加载 %s，请确认依赖是否齐全", driverClass));
        }
    }

    /**
     * 打印检测报告，格式化输出每一项的状态与说明。
     */
    private static void printReport(List<CheckResult> results) {
        System.out.println("================ 项目环境自检报告 ================"); // 输出报告标题
        for (CheckResult result : results) { // 逐项打印检测结果
            System.out.printf("[%s] %-10s %s%n", result.status.symbol, result.name, result.message); // 统一的输出格式
        }
        System.out.println("================================================"); // 输出结尾分隔线
    }

    /**
     * 判断实际版本号是否不低于要求版本号。
     */
    private static boolean isVersionAtLeast(String actual, String required) {
        int[] actualParts = parseVersionParts(actual); // 解析实际版本号
        int[] requiredParts = parseVersionParts(required); // 解析最低要求版本号
        int maxLength = Math.max(actualParts.length, requiredParts.length); // 取最长的长度，避免数组越界
        for (int i = 0; i < maxLength; i++) { // 按位比较大小
            int a = i < actualParts.length ? actualParts[i] : 0; // 若没有对应位则视为 0
            int b = i < requiredParts.length ? requiredParts[i] : 0;
            if (a > b) { // 实际版本更高
                return true;
            }
            if (a < b) { // 实际版本更低
                return false;
            }
        }
        return true; // 所有位都相等，代表满足要求
    }

    /**
     * 将版本号拆分成整数数组，便于比较。
     */
    private static int[] parseVersionParts(String version) {
        String[] tokens = version.split("[^0-9]+"); // 以非数字字符作为分隔符
        List<Integer> parts = new ArrayList<>(); // 保存解析出的数字
        for (String token : tokens) { // 遍历每个分段
            if (!token.isEmpty()) { // 忽略空字符串
                try {
                    parts.add(Integer.parseInt(token)); // 转换成整数
                } catch (NumberFormatException ignored) {
                    // 忽略无法转换的片段
                }
            }
        }
        int[] result = new int[parts.size()]; // 将列表转换成数组
        for (int i = 0; i < parts.size(); i++) {
            result[i] = parts.get(i);
        }
        return result; // 返回数组形式的版本号
    }

    /**
     * 从命令输出中提取第一个看起来像版本号的字段。
     */
    private static String parseVersionFromOutput(String output) {
        Pattern pattern = Pattern.compile("(\\d+(?:\\.\\d+)+)"); // 匹配形如 1.2.3 的版本号
        Matcher matcher = pattern.matcher(output); // 在命令输出中查找
        if (matcher.find()) { // 找到第一个符合的字段
            return matcher.group(1);
        }
        return null; // 未找到版本号时返回 null
    }

    /**
     * 枚举表示检测状态，用符号帮助快速识别。
     */
    private enum Status {
        PASS("✔"), WARN("⚠"), FAIL("✖");

        final String symbol;

        Status(String symbol) {
            this.symbol = symbol;
        }
    }

    /**
     * 描述一项检测结果的数据结构。
     */
    private static class CheckResult {
        final String name;
        final Status status;
        final String message;

        CheckResult(String name, Status status, String message) {
            this.name = name;
            this.status = status;
            this.message = message;
        }
    }
}
