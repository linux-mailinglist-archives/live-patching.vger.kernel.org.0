Return-Path: <live-patching+bounces-52-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E991E7FD802
	for <lists+live-patching@lfdr.de>; Wed, 29 Nov 2023 14:25:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 831FDB21583
	for <lists+live-patching@lfdr.de>; Wed, 29 Nov 2023 13:25:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDCA820323;
	Wed, 29 Nov 2023 13:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vn/UUsYF"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E75AA3;
	Wed, 29 Nov 2023 05:25:38 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1cc9b626a96so51964065ad.2;
        Wed, 29 Nov 2023 05:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701264337; x=1701869137; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s+ZIlO4sg/cP7zZFMR0rAT4hiXFZZBZjMQhwTCp44A4=;
        b=Vn/UUsYFa/vtxTlQyo2fh93u4tFOTG5TqrtwjLebIkfx7VNyF3zq7m8QQ02S+MRsVB
         JmspCM/CuiKCtqkQQNuPjR/xLsc5fl2UdvSHrJH+6GsuYFLP3oH6ACnaVrTYOgxkQzPd
         n6bQtyc30pCPd61f2N1T52GBTreIWhIogSsHwwPh67301Hd6bRjdqau7OKqo4saJq1Fz
         YKkKGEpTeEJiGpfwFuKPlKxsmlHKsG9GlEYzdHVHLZr2o810lna3U/SM8huxivOK7lQi
         KAEtqU6XwreoA+8Ny/fjb66X8k4ATlRoiHYc3kpS2zU0HlUWpHIiivBpkeLNzWXK1On5
         Q8cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701264337; x=1701869137;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s+ZIlO4sg/cP7zZFMR0rAT4hiXFZZBZjMQhwTCp44A4=;
        b=Z++asUhYpBxQ2CyatXoEG/bF34YFRb4pwWy7y1S7SvsStJWKEfRd1HfS71nsd/3Y7b
         ZGqEewpgC/4iRgOUSv6G718D5GvFAtTerfcT8gBOIok/Vwj3g58A7FPPz0xHfF4mspsd
         u+/2Op9DG8ll/2k4jEdE4Wz8DwwTvawb6kBcQKNUqf7611kaXyhIHLMu4cEA56bzIcXy
         1x43jRDd9QoCNZTF9XwpovBmJGe+8N+MnG+BewZEnok7uMrPRQlI+TlGbYz5ki0euDQX
         E0EQWznb2Y8L+Dwoj2+doPAhMdrtObDY0KzZPK+3AKp/X4YwJqDGZl8z0M/DSZHnI5NU
         EaHA==
X-Gm-Message-State: AOJu0YztrlP9PX0yB2HJBEZVozRdHOx9NY39pZ6O2+Ak4jaBnRg9W5JQ
	dkWr5bthN9P/VRW1MBCszPA=
X-Google-Smtp-Source: AGHT+IEbsFuMGe2f9WoNKNKVLwvzz6h3eC7ARvS/r+5SojZiyj1DRk/Ol14MDcz8mvHmLeEdkNH/KQ==
X-Received: by 2002:a17:902:b608:b0:1cf:8cca:4f62 with SMTP id b8-20020a170902b60800b001cf8cca4f62mr16041606pls.46.1701264337664;
        Wed, 29 Nov 2023 05:25:37 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id e13-20020a170902d38d00b001cf5c99f031sm10220343pld.283.2023.11.29.05.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 05:25:35 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 09B1310205C79; Wed, 29 Nov 2023 20:25:29 +0700 (WIB)
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
Subject: [PATCH 0/2] Minor grammatical fixup for livepatch docs
Date: Wed, 29 Nov 2023 20:25:25 +0700
Message-ID: <20231129132527.8078-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=717; i=bagasdotme@gmail.com; h=from:subject; bh=gsdJWBuTmbS/IXxeLqNBKuw152ChX0KZJGcFrysa+Aw=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDKnp1ocE/nG4mD8rDm1iiIhuPL52icCSvVs2S2xpqz+6p /T5gv9xHaUsDGJcDLJiiiyTEvmaTu8yErnQvtYRZg4rE8gQBi5OAZjIBlWGf+rTzte3fcvlzYu0 8P1x8+zeoOTKs78v971VCVf+8fPKSX6gCr+U+/cF88xa1kcdELmjN+GgnffeLGYtqUdVV3as8TF jBQA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

I was prompted to write this little grammar fix series when reading
the fix from Attreyee [1], with review comments requesting changes
to that fix. So here's my version of the fix, with reviews from [1]
addressed (and distinct grammar fixes splitted).

[1]: https://lore.kernel.org/lkml/20231127155758.33070-1-tintinm2017@gmail.com/

Bagas Sanjaya (2):
  Documentation: livepatch: Correct "step on each other's toes" idiom
  Documentation: livepatch: Correct opposite of releasing locks

 Documentation/livepatch/livepatch.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


base-commit: 98b1cc82c4affc16f5598d4fa14b1858671b2263
-- 
An old man doll... just what I always wanted! - Clara


