Return-Path: <live-patching+bounces-533-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8649D969189
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:48:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 31D291F21CAE
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 02:48:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67F2113D8B1;
	Tue,  3 Sep 2024 02:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i9bOTEqA"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C161E49F;
	Tue,  3 Sep 2024 02:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725331684; cv=none; b=SG2DxHbgxLBRrPtmPRr63Kl5iTZ/NE5GLWu+npEVFwNXF1TXNPn8TcxQcmRoumRwmeyCJnfRLFtUVgdxU3FNVNfymergTiyAJh1Gd8HRD+7M9QJBUD24uFmS/q+C1eU7xrxT7U3qSyyjI7K/RycruZzUxFsxCyNVwnrBnIwd1gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725331684; c=relaxed/simple;
	bh=3e9BFcxGMyztGQkt2ajX1gaFZsKe1j90E8wXlDLqqBA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DNjOrgPSFg785+UQbLFEN3ccyiKZX/msqw7Qsf6GdMrorWRSZfWOGuDERhNpvayI/Va3oRP0Chk9OZEkjxsEtsvvzSNqtxknVSnvHYAzY+kOU9B54uBz8JG21zTWDQcnXLTMkEMjJulipMwKkRQV4jfRUIGEgbXZPWrIvIeb+88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i9bOTEqA; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-20543fdb7acso17854225ad.1;
        Mon, 02 Sep 2024 19:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725331682; x=1725936482; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QL+Dy5jYOUZJ3ujUP+UZJfMT8uowfmg+5RGiW1rc9fQ=;
        b=i9bOTEqAKZw9S4hhJdrfOinZKYop0ZfUkOepk0Ki3WPBKiSJt4ycSCmAFUCcU53w8p
         FFNw8HgU2JA9czjo8OSiIRBhDlCOCBWkOFRDsmKsAqPrAlyy8NPPtWcFdIm0BrqWa2SI
         EUSs44zzsuonqeiSWbD7ztLfxImvQtRfssNutKnHpnFshd22kIQU2JjVp1yh690OKJHA
         giDQ6UTSU2G2CpSGlEOTobnT67wCQdhTjttiSkitsMMNBrVGi9uAaqJtyQnv3Q9JocQS
         0erPDIpe1yiavif5GDJnk4neLnVqklI/MXkDGmAOxyKPPLCrM1yTPIhs63JvnGvbLBKz
         VpUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725331682; x=1725936482;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QL+Dy5jYOUZJ3ujUP+UZJfMT8uowfmg+5RGiW1rc9fQ=;
        b=Z4+Pf7N4QMBIIO2mXcTlqe6x0LUEMDE80UScyBGTidIpSDZM46NzqhHP6Q3Rc9Pruy
         oXwCPMUPH913Ax/DgVM/IovkP79zdvGXdGXnZAsmJVpMl+OVlk7y3jHolMSUydz8GJIy
         idIW0e/OqpSEBGdDlI+MRmIHlG73q7MPMStzOFVKpe5h2VnQZcvW4Q26BK6/md3zAxrs
         eiRZp3oZgzgdwLbbhfXihMdhHlozg9q/Un3VrW5gERzB68FCL7iS/J91l0WxkbBaPPPZ
         TM9/3ZUFooUKiiTQHFDDoGsWZz5sutMyWj9mR3vrtl+SyAPu23tLdxY5NtC5Qi1vPt7m
         l8Bw==
X-Forwarded-Encrypted: i=1; AJvYcCVGrI4F6tbEHCfeZwPIzQdmFsa/M6maSfNYb88UahVZL5fhs0Zun6ysS8vKNd0NwHtU/Mm/ETLiYug=@vger.kernel.org, AJvYcCWpeM3Q+A+7LzGqq6UU58wpu+uLNUgEVaX8xw711GxXdt+gWXkdcgxq2ZqyoIxh9BJaowdnjQhAOTczKBDDkg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyVGVnC+kvyWd6v7CynxiPZfx14xPcpRw0BB5AQAMddkIsgyBeQ
	Pcyh1sRvxM9PFZJFu3loWHdpEKMvsDsEIOLu5cm+z+b4rvt0fAjmEtUXNA==
X-Google-Smtp-Source: AGHT+IEoB0+9ktJiczooR9Okr3QAk/6WxwpYddp14Oem1sZYhwrOl+DTFGf3Woowfwqlabg3AqqMVA==
X-Received: by 2002:a17:902:db03:b0:202:4b99:fd27 with SMTP id d9443c01a7336-2054c24a0a1mr83012095ad.51.1725331681939;
        Mon, 02 Sep 2024 19:48:01 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2057f8c12c9sm19433855ad.176.2024.09.02.19.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 19:48:01 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 86CB14936702; Tue, 03 Sep 2024 09:47:58 +0700 (WIB)
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
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH] Documentation: livepatch: Correct release locks antonym
Date: Tue,  3 Sep 2024 09:47:53 +0700
Message-ID: <20240903024753.104609-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=962; i=bagasdotme@gmail.com; h=from:subject; bh=3e9BFcxGMyztGQkt2ajX1gaFZsKe1j90E8wXlDLqqBA=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDGnXym+JuFv+4Gcr+s7IdLLaL6pr/6mXk8uWRfXEzl5sb MOTkjizo5SFQYyLQVZMkWVSIl/T6V1GIhfa1zrCzGFlAhnCwMUpABMxNGT4w82lpXgmutMpfs7s 1937rl2te+8ZrZDLE9q5o7xqwiGF5YwMh0OsFRN3aGl0FrPkpPwKuJW5+MGfMqm6SZP5dqmErOz lAgA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

"get" doesn't properly fit as an antonym for "release" in the context
of locking. Correct it with "acquire".

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/livepatch/livepatch.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/livepatch/livepatch.rst b/Documentation/livepatch/livepatch.rst
index 68e3651e8af925..acb90164929e32 100644
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


