Return-Path: <live-patching+bounces-666-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BDCB97D346
	for <lists+live-patching@lfdr.de>; Fri, 20 Sep 2024 11:04:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1221B1F2143B
	for <lists+live-patching@lfdr.de>; Fri, 20 Sep 2024 09:04:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F243537FF;
	Fri, 20 Sep 2024 09:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F2RYWN0A"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D29F26ADD;
	Fri, 20 Sep 2024 09:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726823052; cv=none; b=Oairn1YkTh397dfa/jfICmgaItB2ezSSQrbicoToniiaLbd7w/Dc7Qdk4GCLmIdQ9NQ8FYSw3YIExqcah5NxpuGnI8denYtBOj5fg8d21CBFfj1AWB9QkYS5KcTUnbIYSUMC4PFamXmBXt9dKrgYNGbW5meqL8oaYFkAtZR7dho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726823052; c=relaxed/simple;
	bh=IoF1Z7aCz2v8yRq907R9NQ54TcPGLf8MrUOnApVk/3o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Kl3UVDoudODzyf05m8eDL6peQRf9/6m6yKiP/80ChbhxpwdGGJPJnnbThqXQYTB4jcdaVGk/weYKTQvYo30c6RjCcmRLFr181TiKCx1gvgGIAsMOFWVbacbtEL/W/gT8146FVUIOl5CtBs9ER/S7Y4DX6HDx9t5L6BWm6yWlJu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F2RYWN0A; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2d86f71353dso1369598a91.2;
        Fri, 20 Sep 2024 02:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726823050; x=1727427850; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eaY8Zg7r9smn8xwtHuog+QfxiQWwagCCZo/SEM4VMT8=;
        b=F2RYWN0AFUhwGjV3qJys5QRxq0w6nrn3DZ1dIgTrHsHbKhI/wpNJN5oSDBZrfB3DhT
         /unK0YF57ocYjvBFmXwVqV/TL6zDAtLv+cN6w8DURPm3x21xwswDiseSoFDCC6laaBU7
         WNrzj8ja2gSMskwAoQ71ByOun2PokPONB5SDf1LgAL66k0rJ+YX0qSyQ7JyxbsOSJCpT
         0JUIDg0EAXI//eS3JJXHggAUBLHJ+1yTkSM1n3pyEGWtTptM3ornwA8jw9OAjnNb8Fyp
         OhOhv7pO8yJ/gH00YBozX5jNf2WjwLpiFEo5YY3Yr9k3dkJHQxEKHB08UmCejWl8tVFr
         esEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726823050; x=1727427850;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eaY8Zg7r9smn8xwtHuog+QfxiQWwagCCZo/SEM4VMT8=;
        b=OjD2ZEMgD9vDrNyf7E6J+psvJKJ38LUYvA7oz8rC7d8MVohGUiw10lSOUjyy2+pZDJ
         NmyKWVrajZ71WxCPwX9Gg5u3O3hC5TkH5XX++XGMmFb3U4RhzUpaMQ3kmci8tzww9gLk
         ZGzOebVhf3mUTm2z0ZazBbgQ+TRE6YXNHH1Y+inytZar7NkIoGFz1ZbbL/f+DaXgPsYM
         ef+GRFPSJigwjX89XRHony0nhy0iNPfNPDHoT2duNWHHymtKG0+7W9ojHYa2gM+covBd
         p1ASxE5TFI21VaQoFABPLhE8/YnD7kKz2ykLEsZOCMfOR4OGBiuKGKMoYITIe9uoHXwm
         Y2OQ==
X-Forwarded-Encrypted: i=1; AJvYcCXp3VUXjI+sQlTG7KZD2qeJllsEQS8LvN3qmFszw5G1hiRb22FJQjWGEN2JrZIwbsYdzA4LPw9Dh4+WBzk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZRY/FTtO5L1T1T+VT0r0v5SPVf9e9qlMcByrxcmz7GJrLbmGK
	9PVvTcNlvND32tCpxUdIfMhgLAv4sjNECwB0SelVnShP94+Qu/+a
X-Google-Smtp-Source: AGHT+IE1ibix8psgcMNMNTJ0QUGORJEMhHM3cOQutH15N5+6dDuqZAdTPudPc4e1QRRYHLblT2YTtw==
X-Received: by 2002:a17:90b:3b50:b0:2d8:adea:9940 with SMTP id 98e67ed59e1d1-2dd7f416207mr2722927a91.16.1726823050482;
        Fri, 20 Sep 2024 02:04:10 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.126])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ee9d8ffsm3483881a91.23.2024.09.20.02.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2024 02:04:10 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] livepatch: introduce 'order' sysfs interface to klp_patch
Date: Fri, 20 Sep 2024 17:04:02 +0800
Message-Id: <20240920090404.52153-1-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As previous discussion, maintainers think that patch-level sysfs interface is the
only acceptable way to maintain the information of the order that klp_patch is 
applied to the system.

However, the previous patch introduce klp_ops into klp_func is a optimization 
methods of the patch introducing 'using' feature to klp_func.

But now, we don't support 'using' feature to klp_func and make 'klp_ops' patch
not necessary.

Therefore, this new version is only introduce the sysfs feature of klp_patch 
'order'.

Regards.
Wardenjohn.

