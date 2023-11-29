Return-Path: <live-patching+bounces-51-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FA447FD7FE
	for <lists+live-patching@lfdr.de>; Wed, 29 Nov 2023 14:25:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE31E1F20F9B
	for <lists+live-patching@lfdr.de>; Wed, 29 Nov 2023 13:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1641220321;
	Wed, 29 Nov 2023 13:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X57ZWKD1"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B313D85;
	Wed, 29 Nov 2023 05:25:37 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-6cc02e77a9cso4103543b3a.0;
        Wed, 29 Nov 2023 05:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701264336; x=1701869136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0vTv5mAp98/8icvpcSLOM8ELBPrnb6MYULdP6ouAnvs=;
        b=X57ZWKD1CvVnPxKdQWqPqML6oZGfUd5h+Lx2becBOZp2zJf73ZeU2ALbqjUpEXJqec
         wPhRexLK6Idee//l+Qr/9jkpC1iK8uMTNyDfQoM+GV/bnI67njZi2YgSD/DJCiLPtTax
         J2VD6FHDOWquScpc0EWOD7iPOgi2GFXr0YBo4+F+5iCAqxR+VjwRXv5N2bSDtdPLadXJ
         W4GtyFR0RMRW/egdgmtP5ztmJtwELWQzwLf2BycO0qg9BC3jQDEK/v8FiH+gvvrRtQD0
         rRFjL9AGFhz8g3+bFew7ErVyfbvt3c8aPKm2QXgBVeKkf9yJJdoHUTMy/wfrgwKLgToe
         3UeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701264336; x=1701869136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0vTv5mAp98/8icvpcSLOM8ELBPrnb6MYULdP6ouAnvs=;
        b=IIfT5VEciexLv/ZoSX/euzs+K0Z/mzgqRimA9xbW6tfZd8lQ3dMzB3IzAsVd5SZYVo
         BJpr+EGb4WVXO0USSd9lqq9qNOcfVja+GAl5+ESeQb+TSGBn0WGn+XAW53Sg7eajwTyr
         L28dhRZVUYkCqvJZlplF1+NzDETNgMH2Uu8gxd3BROg9Sbub13I/93TF4DudwJ/54pub
         HDJ5td0nrCtRh4dEPlPXgqabZZf1nOshx6xXkhHR60q9rPutB3fC22JSoTlgz+W7Druo
         Xoxq12782V5sMegO9/a9pgAhEfxyUUmLTanPE3YZrjhxCUewwYg8wofd5RJhmqbTgWHi
         Dpqg==
X-Gm-Message-State: AOJu0YwQrN1zEg52aQ7IZGcYiLo5p0l/fLjUGlZ1F82xoCTp4PBbvrkS
	XkmLwi41lzpzrdr0clgAHjQ=
X-Google-Smtp-Source: AGHT+IFUD28p6w/oFS/NlXkaF+l0N93slTVLGP0uMB13s2leDFOaQOOp2Jdfg/eSHMIb3tdsvjbuDg==
X-Received: by 2002:a05:6a20:1581:b0:18c:c37:35d4 with SMTP id h1-20020a056a20158100b0018c0c3735d4mr21630421pzj.14.1701264336594;
        Wed, 29 Nov 2023 05:25:36 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id y192-20020a638ac9000000b005c2967852c5sm11051185pgd.30.2023.11.29.05.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 05:25:35 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 4054B10206DD0; Wed, 29 Nov 2023 20:25:30 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux Kernel Livepatching <live-patching@vger.kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Attreyee Mukherjee <tintinm2017@gmail.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH 2/2] Documentation: livepatch: Correct opposite of releasing locks
Date: Wed, 29 Nov 2023 20:25:27 +0700
Message-ID: <20231129132527.8078-3-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231129132527.8078-1-bagasdotme@gmail.com>
References: <20231129132527.8078-1-bagasdotme@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1019; i=bagasdotme@gmail.com; h=from:subject; bh=+sPWGCF2lgNx7PNzcgyT4hcPq66q7XIxYBrXPX3DPxw=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDKnp1ofsDrFMOvtBTnL+hHLFObXTupavXZAmI6Up67oqr 13495LdHaUsDGJcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZjIrD8M/0Pf3fy0vH+Pt/E2 fsMJt5xtG56+qzia7dZw5NdJ5cPaYQsY/oc9XsbowWPjL5j6kNf0mEuCqPp+Rt25te4X3L4L/n7 exQwA
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

The opposite action of releasing locks is acquiring them, not getting
them (as in configuration options; the inverse of such action is
setting options). Correct it.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/livepatch/livepatch.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/livepatch/livepatch.rst b/Documentation/livepatch/livepatch.rst
index 000059b3cbde49..53b49dafd7ded8 100644
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
An old man doll... just what I always wanted! - Clara


