Return-Path: <live-patching+bounces-1554-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37B04AEAB38
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:01:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D69D43BF588
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96E83271447;
	Thu, 26 Jun 2025 23:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VWICsbqs"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFAD270EC1;
	Thu, 26 Jun 2025 23:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982188; cv=none; b=l//3Fs7qKO5E7BX3grOusMliclD2PNoL4DR3ZJe3DgaqZqYwodpkWiAKMXazcmAIylkkqJ4eksi2HsEjkitSdHo1uRjRe9aYZfVDi89vEElGUmt0unc7fIvcuSqMi4G367ZRPIVs8IT6cLEe+VEgRRfWdxb32YS/kcs+LgG5dv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982188; c=relaxed/simple;
	bh=K5QjetbzOxYE8rbazG7nfv/5bbPl/F0QYOWaQl42WCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLVoRwA0YccQFToeqSQZb+DGatotyYcbCUp9uu27g9CcByqXoNC7FbFBezz80UPOR3M7K6u8TTl0texfnFXbFlCBvYRKGjQy6LrgAkdqFopSe39U1sWovz1yUAqMzztp2rNfZs2XStWXIfN1F6E0uy5j7OMz4Rmga2tDmDFIQGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VWICsbqs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14F3C4CEEB;
	Thu, 26 Jun 2025 23:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982188;
	bh=K5QjetbzOxYE8rbazG7nfv/5bbPl/F0QYOWaQl42WCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWICsbqs3Z47jg1DOgXiEskLkEJLjlwe20a9qGQvUMfg0K0F7L8eVbH8wIUTYAkK6
	 YkNY4/dySXj7EZCAWHoX5HGFrl+BJfDnQ5LvDV+QzhICw8E+U63yK3c2QvrCUAIYrV
	 SrjSzSCusIhnOMoI84mFqwOFDJ1o5wSekywWghhco18oPCJeAUgVkIbchfFKNdvske
	 BY8VFJxpx2p4ERMBZJzqiw/r5pldkHg2R9Nz49BV3c9IHXg0Pw8iM4CYvl1vpZXQwS
	 6qjHBi2LnkSQRpuJC3GonphOf/Gp8uw9iV+0PxSFjQ2AyeQrPngmw0j8mcQoBgsH9f
	 rJqDgOIxSqY+Q==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>
Subject: [PATCH v3 24/64] objtool: Remove .parainstructions reference
Date: Thu, 26 Jun 2025 16:55:11 -0700
Message-ID: <35844c25d06dff0681a63d3c0a25c083cc4c833d.1750980517.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750980516.git.jpoimboe@kernel.org>
References: <cover.1750980516.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The .parainstructions section no longer exists since the following
commit:

  60bc276b129e ("x86/paravirt: Switch mixed paravirt/alternative calls to alternatives").

Remove the reference to it.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/check.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 4e779bf8fcae..61e44b927b99 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -4431,7 +4431,6 @@ static int validate_ibt(struct objtool_file *file)
 		    !strcmp(sec->name, ".altinstructions")		||
 		    !strcmp(sec->name, ".ibt_endbr_seal")		||
 		    !strcmp(sec->name, ".orc_unwind_ip")		||
-		    !strcmp(sec->name, ".parainstructions")		||
 		    !strcmp(sec->name, ".retpoline_sites")		||
 		    !strcmp(sec->name, ".smp_locks")			||
 		    !strcmp(sec->name, ".static_call_sites")		||
-- 
2.49.0


