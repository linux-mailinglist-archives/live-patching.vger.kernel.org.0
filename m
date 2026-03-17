Return-Path: <live-patching+bounces-2230-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QBmhDw3buWlHOgIAu9opvQ
	(envelope-from <live-patching+bounces-2230-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 23:51:57 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BE032B3387
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 23:51:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A11D8302490E
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 22:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C91173F7A9A;
	Tue, 17 Mar 2026 22:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SEISourM"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61C33F789E;
	Tue, 17 Mar 2026 22:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773787898; cv=none; b=NqHgIZnuwiMBT6angEkI9eqaCx6YQR3UVf5lS03whW2q0XSaY1UWPxHXEowNhN3LdDt7W6UhfairoITjB/l+9kabI/eekPOZNrbhroX9q32UTpuog+TK7OltiYBlzQEEwCZO8rASuhipWSSx2AancyCJPc5ain5pudnY9AHSjHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773787898; c=relaxed/simple;
	bh=Z4h9ZFd5elXdJi4wGJjXHxGFSPzvcEc4LERNhrT0EmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ba02IWoHTej++wKTAI6x/ZEbfg41FDny9UY1S5pLCYczgZ47hfMPrScH9ex98/nTgg3xmPSXkYN+MjtkftZBxsfWzJf/CBaCaEG29tav05/YY5ZOG9PuNoKxz+nM1On+BmCvxVlkO+2Rqw/d4vfcMuri7U9V/+5NBxs09S6h9Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SEISourM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B9AC2BCC9;
	Tue, 17 Mar 2026 22:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773787898;
	bh=Z4h9ZFd5elXdJi4wGJjXHxGFSPzvcEc4LERNhrT0EmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEISourMafINQsXcWHU2ATrORkFpttHBZjwLuKpsPpemhVE9HhqmUB/CM6T7M+htA
	 DYR0J4BPPJCqkO96EfctVeIRhNhiRLAvPU5cmdOsi90QQyMQrniTmVNwycGCcxdZtP
	 hUAS/YwgmhrOOeAMFmuLxT76aTwikXppqOtUIK3+2H4AgFwL2Ka+5/z9AvxduJ4KSH
	 muy19v9dvnYxKctPAlxrXxOPWTPgau7SvFtbYeNssU2rgJd8uB0xiw/MssIc9cRMp9
	 eV/paCwa/QWLJSEsjjT7UXNvOhbYHqXo7B093waN/tT+DwUawc6WLzRPUJASZ2Sb6Z
	 NlLQqnKt12HXw==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v2 10/12] objtool: Reuse consecutive string references
Date: Tue, 17 Mar 2026 15:51:10 -0700
Message-ID: <4d211040356fe169b4236b3deea1cdff80e9babc.1773787568.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773787568.git.jpoimboe@kernel.org>
References: <cover.1773787568.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2230-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1BE032B3387
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

For duplicate strings, elf_add_string() just blindly adds duplicates.

That can be a problem for arm64 which often uses two consecutive
instructions (and corresponding relocations) to put an address into a
register, like:

  d8:   90000001        adrp    x1, 0 <meminfo_proc_show>       d8: R_AARCH64_ADR_PREL_PG_HI21  .rodata.meminfo_proc_show.str1.8
  dc:   91000021        add     x1, x1, #0x0    dc: R_AARCH64_ADD_ABS_LO12_NC   .rodata.meminfo_proc_show.str1.8

Referencing two different string addresses in the adrp+add pair can
result in a corrupt string addresses.  Detect such consecutive reuses
and force them to use the same string.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index b911abe3a15e..5ccae2c937dc 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -1374,6 +1374,8 @@ struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name)
 
 unsigned int elf_add_string(struct elf *elf, struct section *strtab, const char *str)
 {
+	static unsigned int last_off;
+	static const char *last_str;
 	unsigned int offset;
 
 	if (!strtab)
@@ -1382,17 +1384,22 @@ unsigned int elf_add_string(struct elf *elf, struct section *strtab, const char
 		ERROR("can't find .strtab section");
 		return -1;
 	}
-
 	if (!strtab->sh.sh_addralign) {
 		ERROR("'%s': invalid sh_addralign", strtab->name);
 		return -1;
 	}
 
+	if (last_str && !strcmp(last_str, str))
+		return last_off;
+
 	offset = ALIGN(sec_size(strtab), strtab->sh.sh_addralign);
 
 	if (!elf_add_data(elf, strtab, str, strlen(str) + 1))
 		return -1;
 
+	last_str = str;
+	last_off = offset;
+
 	return offset;
 }
 
-- 
2.53.0


