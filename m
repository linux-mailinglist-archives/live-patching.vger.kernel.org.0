Return-Path: <live-patching+bounces-106-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A839781D68E
	for <lists+live-patching@lfdr.de>; Sat, 23 Dec 2023 22:08:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 572831F21EF5
	for <lists+live-patching@lfdr.de>; Sat, 23 Dec 2023 21:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6007515EBD;
	Sat, 23 Dec 2023 21:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fv6YQWgD"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090F215E96;
	Sat, 23 Dec 2023 21:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3b9f8c9307dso2696069b6e.0;
        Sat, 23 Dec 2023 13:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703365719; x=1703970519; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KK4sv6eXSGMQXDR34E1Vn5NVCVeb5+OOloFC/hz95jk=;
        b=fv6YQWgDih3lqZEZoeQD2cZp1MRW3PAuKi87oux4MW+w782zGZtoMmhjTjYJ+VqKE1
         8QZfsrZBjxJDotYCqnNolcd41+NV8RaTuofPqu+wurPcnvnSeoMzsWqh7sJAI53vG+EZ
         /bgoBv/x9kD1ICNEfQITgrtqcncZGXmr6ZfMYSZhHXDAhTaqXcY6q9nt8CLNFCgbsE5i
         U4qgjFST3V/awibQiW8Etg58ZGxresbT/UShYSMoBEilisHiP3TI7mbsa3e1RKrvhjmN
         I/hVHv5ah7ncfhIt3BLGPP3XyjfzQkZJ5Ijdoctd2V7QwbD0ehkaxDrpaQ0No6p+CTYc
         CfaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703365719; x=1703970519;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KK4sv6eXSGMQXDR34E1Vn5NVCVeb5+OOloFC/hz95jk=;
        b=enHXsVVXZ6msnwgxgJiyYGKrhV/HnAKUvD3V/+b+WsPFnS40MxN9rTgF+sYFHgIJpH
         Nl4HELduDNYdhls0N0KMvkghsMOftJdHow45bRJRGCAlB9vyJ5teql8dqdz+Nn9n1yqu
         EeYg5K6ZditWXmz6+ange5IB55T1Y+gAIjdgsRHGlsshrZ0o5t0Pr4qSw7v9ocezgInP
         mN1bCvifg4ka8wl+A5WaVW6C4lYdijwAxwKKgk2+97CjBoJNlKLPaQXKEC84sI6o+K8e
         9sYRIvSdDFimQW/EXJ2aDpWakmgk/RiqnnhG/Tob3Uj1cv2rOPEI9Vf1UEuGjm/0Echl
         9uVA==
X-Gm-Message-State: AOJu0YzmtnxWpR1eYtL51cPoW8zHz/PSMCpZtDiNuskgqcvYt9aysppp
	xBc9QoA8+e1RvDqda5rO/V4=
X-Google-Smtp-Source: AGHT+IHxVrWgu8VONajTCDaqEM+idR34VsDuibANdpRezTOueUFgH1u6wUMkE3oS3xlSBEaRpLCuCw==
X-Received: by 2002:a05:6808:d47:b0:3b8:b20d:cecd with SMTP id w7-20020a0568080d4700b003b8b20dcecdmr4444603oik.32.1703365718904;
        Sat, 23 Dec 2023 13:08:38 -0800 (PST)
Received: from attreyee-HP-Pavilion-Laptop-14-ec0xxx.. ([27.5.150.118])
        by smtp.gmail.com with ESMTPSA id n15-20020a6563cf000000b005cdf0b46fecsm3270455pgv.81.2023.12.23.13.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Dec 2023 13:08:38 -0800 (PST)
From: attreyee-muk <tintinm2017@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	corbet@lwn.net
Cc: attreyee-muk <tintinm2017@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	live-patching@vger.kernel.org
Subject: [PATCH] Documentation/livepatch: Update terminology in livepatch
Date: Sun, 24 Dec 2023 02:28:14 +0530
Message-Id: <20231223205813.32083-1-tintinm2017@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the sentence in livepatch.rst to: "Functions are there for a reason. Take some input parameters, acquire or release locks, read, process, and write some data in a defined way."

Signed-off-by: Attreyee Mukherjee <tintinm2017@gmail.com>
---
 Documentation/livepatch/livepatch.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/livepatch/livepatch.rst b/Documentation/livepatch/livepatch.rst
index 68e3651e8af9..acb90164929e 100644
--- a/Documentation/livepatch/livepatch.rst
+++ b/Documentation/livepatch/livepatch.rst
@@ -50,7 +50,7 @@ some limitations, see below.
 3. Consistency model
 ====================
 
-Functions are there for a reason. They take some input parameters, get or
+Functions are there for a reason. They take some input parameters, acquire or
 release locks, read, process, and even write some data in a defined way,
 have return values. In other words, each function has a defined semantic.
 
-- 
2.34.1


