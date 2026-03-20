<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>实时手语识别系统 - 计算机设计大赛</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
            scroll-behavior: smooth;
        }

        /* 全局样式 */
        body {
            background: #f7f9fc;
            color: #2d3748;
        }

        /* 导航栏 */
        nav {
            position: fixed;
            top: 0;
            width: 100%;
            background: #2b6cb0;
            padding: 0 30px;
            height: 65px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            z-index: 999;
        }
        .logo {
            color: white;
            font-size: 22px;
            font-weight: bold;
        }
        .nav-links a {
            color: white;
            margin-left: 24px;
            text-decoration: none;
            font-size: 15px;
            transition: color 0.3s;
        }
        .nav-links a:hover {
            color: #bee3f8;
        }

        /* 英雄区（带视差动效） */
        .hero {
            margin-top: 65px;
            height: 520px;
            background: linear-gradient(135deg, #2b6cb0, #38b2ac);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .hero::before {
            content: "";
            position: absolute;
            width: 200%;
            height: 200%;
            background: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="none"><path d="M0,0 L100,0 L100,70 Q50,100 0,70 Z" fill="rgba(255,255,255,0.1)"/></svg>');
            animation: wave 15s linear infinite alternate;
        }
        @keyframes wave {
            from { transform: translateX(-5%) }
            to { transform: translateX(5%) }
        }
        .hero-content {
            position: relative;
            z-index: 1;
            max-width: 800px;
            animation: fadeInUp 1s ease-out;
        }
        .hero h1 {
            font-size: 44px;
            margin-bottom: 16px;
            text-shadow: 0 2px 8px rgba(0,0,0,0.2);
        }
        .hero p {
            font-size: 18px;
            line-height: 1.7;
            margin-bottom: 32px;
        }
        .btn-hero {
            padding: 14px 36px;
            background: white;
            color: #2b6cb0;
            border: none;
            border-radius: 30px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: transform 0.3s, box-shadow 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        .btn-hero:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 16px rgba(0,0,0,0.15);
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* 通用模块 */
        .section {
            max-width: 1200px;
            margin: 80px auto;
            padding: 0 20px;
        }
        .section-title {
            text-align: center;
            font-size: 30px;
            color: #2b6cb0;
            margin-bottom: 50px;
            position: relative;
        }
        .section-title::after {
            content: "";
            width: 60px;
            height: 3px;
            background: #38b2ac;
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
        }

        /* 项目简介 */
        .intro {
            background: white;
            padding: 40px;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            line-height: 1.8;
            font-size: 16px;
            color: #4a5568;
        }

        /* 核心功能卡片 */
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 28px;
        }
        .feature-card {
            background: white;
            border-radius: 16px;
            padding: 32px 24px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            transition: transform 0.3s, box-shadow 0.3s;
            opacity: 0;
            transform: translateY(40px);
        }
        .feature-card.show {
            opacity: 1;
            transform: translateY(0);
        }
        .feature-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 24px rgba(0,0,0,0.08);
        }
        .feature-icon {
            font-size: 36px;
            margin-bottom: 16px;
            color: #2b6cb0;
        }
        .feature-card h3 {
            font-size: 20px;
            color: #2b6cb0;
            margin-bottom: 12px;
        }
        .feature-card p {
            font-size: 15px;
            line-height: 1.7;
            color: #666;
        }

        /* 识别流程 */
        .flow-container {
            background: white;
            padding: 50px 30px;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        .flow-steps {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            align-items: center;
            gap: 16px;
            margin-top: 30px;
        }
        .flow-step {
            background: #ebf8ff;
            padding: 18px 24px;
            border-radius: 12px;
            font-weight: bold;
            color: #2b6cb0;
            position: relative;
            white-space: nowrap;
        }
        .flow-step::after {
            content: "→";
            position: absolute;
            right: -16px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 22px;
            color: #999;
        }
        .flow-step:last-child::after {
            display: none;
        }

        /* 界面展示（图片区） */
        .screenshots {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 24px;
        }
        .screenshot-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            transition: transform 0.3s;
        }
        .screenshot-card:hover {
            transform: scale(1.03);
        }
        .screenshot-card img {
            width: 100%;
            height: 400px;
            object-fit: cover;
        }
        .screenshot-info {
            padding: 16px;
            text-align: center;
        }
        .screenshot-info h4 {
            font-size: 16px;
            color: #2b6cb0;
        }

        /* 视频展示区 */
        .videos {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 24px;
        }
        .video-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        .video-card video {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        .video-info {
            padding: 16px;
        }
        .video-info h4 {
            font-size: 16px;
            color: #2b6cb0;
            margin-bottom: 6px;
        }
        .video-info p {
            font-size: 13px;
            color: #666;
        }

        /* 下载APP区域 */
        .download-section {
            background: linear-gradient(135deg, #2b6cb0, #38b2ac);
            color: white;
            text-align: center;
            padding: 60px 30px;
            border-radius: 20px;
            margin: 80px auto;
            max-width: 1000px;
        }
        .download-section h2 {
            font-size: 32px;
            margin-bottom: 16px;
        }
        .download-section p {
            font-size: 17px;
            margin-bottom: 32px;
        }
        .download-btn {
            padding: 16px 42px;
            background: white;
            color: #2b6cb0;
            font-size: 18px;
            font-weight: bold;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            transition: transform 0.3s, box-shadow 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        .download-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 6px 16px rgba(0,0,0,0.15);
        }

        /* 技术架构 */
        .architecture {
            background: white;
            padding: 50px 30px;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            text-align: center;
        }
        .architecture p {
            font-size: 16px;
            line-height: 1.8;
            color: #4a5568;
            margin-bottom: 20px;
        }
        .arch-layer {
            background: #ebf8ff;
            padding: 16px;
            margin: 12px auto;
            max-width: 600px;
            border-radius: 8px;
            color: #2b6cb0;
            font-weight: bold;
        }

        /* 页脚 */
        footer {
            background: #2d3748;
            color: #a0aec0;
            text-align: center;
            padding: 36px 20px;
            font-size: 14px;
        }
        .footer-links {
            margin-bottom: 16px;
        }
        .footer-links a {
            color: #a0aec0;
            margin: 0 12px;
            text-decoration: none;
        }
        .footer-links a:hover {
            color: white;
        }
    </style>
</head>
<body>

<!-- 导航栏 -->
<nav>
    <div class="logo">实时手语识别系统</div>
    <div class="nav-links">
        <a href="#home">首页</a>
        <a href="#intro">项目简介</a>
        <a href="#features">核心功能</a>
        <a href="#flow">识别流程</a>
        <a href="#screenshots">界面展示</a>
        <a href="#videos">演示视频</a>
        <a href="#tech">技术架构</a>
        <a href="#download">下载APP</a>
    </div>
</nav>

<!-- 英雄区 -->
<section class="hero" id="home">
    <div class="hero-content">
        <h1>让手语被看见、被听见</h1>
        <p>基于端侧AI的实时手语识别系统，助力无障碍沟通，为听障人士打造更便捷的交流方式</p>
        <a href="#download" class="btn-hero">立即下载体验</a>
    </div>
</section>

<!-- 项目简介 -->
<section class="section" id="intro">
    <h2 class="section-title">项目简介</h2>
    <div class="intro">
        <p>本项目是一款运行于安卓平台的实时手语识别应用，通过手机摄像头采集手势动作，利用轻量级AI模型在端侧完成推理，实现手语到文字与语音的自动转换。系统支持自定义手势录入，无需联网即可运行，在保护用户隐私的同时，为听障人士与普通人之间搭建起无障碍沟通的桥梁。</p>
        <br>
        <p>项目采用分层架构设计，界面简洁易用，识别准确率高，适用于日常交流、课堂教学等多种场景，荣获中国大学生计算机设计大赛推荐作品。</p>
    </div>
</section>

<!-- 核心功能 -->
<section class="section" id="features">
    <h2 class="section-title">核心功能</h2>
    <div class="features-grid">
        <div class="feature-card">
            <div class="feature-icon">📷</div>
            <h3>实时手势采集</h3>
            <p>调用手机摄像头实时采集图像，自动提取手部关键点信息，帧率稳定、响应迅速，确保手势捕捉精准。</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">🤖</div>
            <h3>端侧AI推理</h3>
            <p>基于TensorFlow Lite部署轻量神经网络，在本地完成特征提取与匹配，识别速度快、功耗低，不依赖网络环境。</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">✍️</div>
            <h3>自定义手势录制</h3>
            <p>支持3次采样、回放质检、平均特征生成，用户可创建专属手势模板，满足个性化交流需求。</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">🔊</div>
            <h3>文字与语音播报</h3>
            <p>识别结果实时展示并支持语音播报，让听障人士与他人交流更加顺畅自然，提升沟通效率。</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">💾</div>
            <h3>本地数据存储</h3>
            <p>手势模板与特征数据本地保存，安全隐私，可随时管理、查看与修改，保障用户数据安全。</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">🔄</div>
            <h3>版本更新检测</h3>
            <p>支持手动与自动两种更新检查方式，可获取最新功能与优化，保证应用持续可用。</p>
        </div>
    </div>
</section>

<!-- 识别流程 -->
<section class="section" id="flow">
    <h2 class="section-title">识别流程</h2>
    <div class="flow-container">
        <div class="flow-steps">
            <div class="flow-step">开启相机</div>
            <div class="flow-step">帧采集</div>
            <div class="flow-step">关键点提取</div>
            <div class="flow-step">40帧滑动窗口</div>
            <div class="flow-step">TFLite推理</div>
            <div class="flow-step">相似度匹配</div>
            <div class="flow-step">输出识别结果</div>
        </div>
    </div>
</section>

<!-- 界面展示（可替换为你的APP截图） -->
<section class="section" id="screenshots">
    <h2 class="section-title">界面展示</h2>
    <div class="screenshots">
        <div class="screenshot-card">
            <!-- 替换为你的识别主页面截图 -->
            <img src="https://picsum.photos/id/1/600/800" alt="识别主页面">
            <div class="screenshot-info">
                <h4>识别主页面</h4>
            </div>
        </div>
        <div class="screenshot-card">
            <!-- 替换为你的手势添加页面截图 -->
            <img src="https://picsum.photos/id/2/600/800" alt="手势添加页面">
            <div class="screenshot-info">
                <h4>手势添加页面</h4>
            </div>
        </div>
        <div class="screenshot-card">
            <!-- 替换为你的"我的"页面截图 -->
            <img src="https://picsum.photos/id/3/600/800" alt="我的页面">
            <div class="screenshot-info">
                <h4>"我的"页面</h4>
            </div>
        </div>
    </div>
</section>

<!-- 演示视频（可替换为你的项目视频） -->
<section class="section" id="videos">
    <h2 class="section-title">演示视频</h2>
    <div class="videos">
        <div class="video-card">
            <video controls>
                <!-- 替换为你的视频链接 -->
                <source src="#" type="video/mp4">
                您的浏览器不支持视频播放
            </video>
            <div class="video-info">
                <h4>实时识别演示</h4>
                <p>展示手势识别的实时效果与交互体验</p>
            </div>
        </div>
        <div class="video-card">
            <video controls>
                <!-- 替换为你的视频链接 -->
                <source src="#" type="video/mp4">
                您的浏览器不支持视频播放
            </video>
            <div class="video-info">
                <h4>自定义手势录制</h4>
                <p>演示如何添加并训练新手势</p>
            </div>
        </div>
    </div>
</section>

<!-- 技术架构 -->
<section class="section" id="tech">
    <h2 class="section-title">技术架构</h2>
    <div class="architecture">
        <p>系统采用清晰的分层架构设计，各模块职责明确，便于维护与扩展：</p>
        <div class="arch-layer">Android UI 层 → 界面展示与用户交互</div>
        <div class="arch-layer">业务逻辑层 → 流程控制与状态管理</div>
        <div class="arch-layer">数据处理层 → Camera2 / MediaPipe 关键点提取</div>
        <div class="arch-layer">AI推理层 → TensorFlow Lite 模型推理</div>
        <div class="arch-layer">数据存储层 → 本地手势库与网络更新</div>
    </div>
</section>

<!-- 下载APP区域 -->
<section class="download-section" id="download">
    <h2>下载《实时手语识别系统》APP</h2>
    <p>即刻体验无障碍沟通，让手语被世界听见</p>
    <!-- 👇 把 # 替换为你的真实下载链接即可 -->
    <a href="#" class="download-btn">立即下载</a>
</section>

<!-- 页脚 -->
<footer>
    <div class="footer-links">
        <a href="#">关于我们</a>
        <a href="#">联系我们</a>
        <a href="#">使用条款</a>
    </div>
    <p>© 2025 实时手语识别系统开发团队 | 中国大学生计算机设计大赛参赛作品</p>
</footer>

<script>
    // 滚动动画：元素进入视口时淡入
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('show');
            }
        });
    }, { threshold: 0.1 });

    document.querySelectorAll('.feature-card').forEach(el => {
        observer.observe(el);
    });
</script>

</body>
</html>
