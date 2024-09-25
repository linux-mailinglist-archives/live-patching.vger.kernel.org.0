Return-Path: <live-patching+bounces-683-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01ACF985312
	for <lists+live-patching@lfdr.de>; Wed, 25 Sep 2024 08:41:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32C941C22CA5
	for <lists+live-patching@lfdr.de>; Wed, 25 Sep 2024 06:41:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10A97156649;
	Wed, 25 Sep 2024 06:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ex2WB3No"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D5E156872;
	Wed, 25 Sep 2024 06:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727246477; cv=none; b=cfLSDN9FtRY2044KaPmzpc3IJztHTUXeRbE4fuie9BsWUgidwGH0CHALyExMq4M2/rocWIjRAcZcVA0VLV8LWSsfaKUOTxYRb9Yj0ZeawIC2JzCpukIx5MUUKv5l0Hrgns/1+RKAXb+rvEzXzbsNb2pIISzNixwa+umyUH2u9m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727246477; c=relaxed/simple;
	bh=Nw97WsesaxK9KAqNI/Wm7QXsl26QnGaico0tioFue1Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bRz/5jMbsfuF9kAc9nWle4Rhem1UfP9ecrGs2tGXdTjRYXyKtGxPpmVGRuStWjhXDGkVN2rZFGyitV5zpgk6KQa5QmDzvIYkEQUJPKovaFjunOUcbD46quAIZU/0y2nG5Tboc07x11e6sSaHpL45lvTqQJH9FWUO+wXmRimFyT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ex2WB3No; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7179802b8fcso4521048b3a.1;
        Tue, 24 Sep 2024 23:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727246475; x=1727851275; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UudjcCFoYrSDJU9P72NdXY6ZjlpNEd3W29mVUFxsDU8=;
        b=Ex2WB3NoaysV4sPyPic1cxWAaknkG5puoJkf3gaUsBxb9U4+RPB56ydgD5oX1flkQ/
         CO/pIf83KKGxpPkqwjKCWaCuc7LgmEhGmh2l4yF7YY15KCurQav5+IdkVB5prl9nf1rt
         bJFgeG3xuWipjQsLKqpw4cG4Rin/zzoII5nwkfQZ3We/Vr0XXZy2UHLnM00A47hE6NSI
         q+U/Ylx8HwiXxohT2XISVe9oVovhPCaSacrdUjnHIZ7XyLts0LIUQzqY6gw6k/JGMwU1
         CvOb97mQo3MTFhnt7JXGHTiXvYEmaMKfMtm6yXX/j5tdJQMYGtI1gNwje9+2duzEHQI6
         Qjrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727246475; x=1727851275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UudjcCFoYrSDJU9P72NdXY6ZjlpNEd3W29mVUFxsDU8=;
        b=DLc1QbsgFy3szt4Bju4xYZvxoD2XcYyJzX5HGeO5mqZzj4NibSUsTi36XkZtTCQzYL
         qqTSX1tRl4lIr/m41gZPtWNg25SKqN/drCgNJmgZHGHmzUXFcunDcYxkgZkVhzUkwzZB
         xgP9x9qr1AZrX4B2r/MeMuFo4SI6WxS26f9V+6XY78edLXSkWfuYMhmnQt/NdiGIkhq3
         Fno1IwK6fetiHMLSb4pvtpxRk5mPLJBfl1SmEFAhPhdIqcbQ2zhGqd3uu77TGgjzOgPk
         aqOJLM0S6Sd2SNCwNA4O9WDLYp8nP4qZdSUTi9ueFEyFjv4Mhq5wwDa7hlhsereVGxJ1
         3k6g==
X-Forwarded-Encrypted: i=1; AJvYcCW1gEL14+kcw1pVUimHUeBgv+KEBCJKuWz3EDzUjulU8m8XTiqtRjW6eQr3AeelkNVafSbw0mqFiYLrAac=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfndnhK5cbZKpxqmXntS5rrpzlWwgBRM+66Zenm8sEUFWJqfYU
	6CP/B5KfTxrhI3iufS24KzvWkuyZ3179SdXl8Q4dTl8vjjzCPWPz
X-Google-Smtp-Source: AGHT+IFNThAylM4apGV0UhSBzkshJeKDA5Rzu0aYIcPbldCyZetZmU8BAo6Z9hixWiRPx/1XbRVzww==
X-Received: by 2002:a05:6a00:2e94:b0:718:e162:7374 with SMTP id d2e1a72fcca58-71b0aaa1c23mr2806110b3a.5.1727246474833;
        Tue, 24 Sep 2024 23:41:14 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.121])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71afc8443e0sm2139578b3a.62.2024.09.24.23.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 23:41:14 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH] Documentation: Add description to stack_order interface
Date: Wed, 25 Sep 2024 14:40:47 +0800
Message-Id: <20240925064047.95503-3-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20240925064047.95503-1-zhangwarden@gmail.com>
References: <20240925064047.95503-1-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update description of klp_patch stack_order sysfs interface to
livepatch ABI documentation.

Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
index a5df9b4910dc..9cad725a69c7 100644
--- a/Documentation/ABI/testing/sysfs-kernel-livepatch
+++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
@@ -47,6 +47,14 @@ Description:
 		disabled when the feature is used. See
 		Documentation/livepatch/livepatch.rst for more information.
 
+What:           /sys/kernel/livepatch/<patch>/stack_order
+Date:           Sep 2024
+KernelVersion:  6.12.0
+Contact:        live-patching@vger.kernel.org
+Description:
+		This attribute record the stack order of this livepatch module
+		applied to the running system.
+
 What:		/sys/kernel/livepatch/<patch>/<object>
 Date:		Nov 2014
 KernelVersion:	3.19.0
-- 
2.18.2


