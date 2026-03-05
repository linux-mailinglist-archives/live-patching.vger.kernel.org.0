Return-Path: <live-patching+bounces-2120-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cPAlGlv5qGlzzwAAu9opvQ
	(envelope-from <live-patching+bounces-2120-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 04:32:43 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B28120A8A9
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 04:32:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 46AD0303C389
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 03:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 267A428C037;
	Thu,  5 Mar 2026 03:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k8+xaC8Y"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035242882D7;
	Thu,  5 Mar 2026 03:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772681519; cv=none; b=kLDtkD6iCXLn5IQvyjtAFOJA4xOnqCWE20NnDNudB7PWWpjVBYADKSOmWe7WEKHmpLe6/g/L32WLqWeMshTKqGoCvLn9qo+N2Ef5lLPPXOt+J2KR/grwTywp8HCUDIZdFCj35hmc69aQn+kWqtoKK+nu4THm+RQt1l5PNK1Rbf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772681519; c=relaxed/simple;
	bh=CfP2DFBojtfnSTUyVXwvbIwOJH/gBb2u2wzP+UFC7hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZorjCopPlOCLCiI+Wgt0kHzhiwqNlVBlOa3NOwFicpVGl0w+PJFsc/WH84/DFq226xuXw+Hp/bHuJlyG3vEwlJzE6Y+fjMRAKZMBpPiF93EOTJXwpFcepEhMNWuh2/cuw3rFSPtKP+Ww0k8ZTs3cb5UJT+JzQwxUQqiDyiQmks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k8+xaC8Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD774C2BCB0;
	Thu,  5 Mar 2026 03:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772681518;
	bh=CfP2DFBojtfnSTUyVXwvbIwOJH/gBb2u2wzP+UFC7hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8+xaC8YqfE6gU2/m9z8R8CU4ZtMOnKh6oZcO4Ro2BZbPyVsMhee6JY06BnMAaCz9
	 u8zu+NzWjBt+hQjDDgnH/gDDjLGrgtRI+i2V51yXvnAYa+IY/aT1REYDZxXXj3G56y
	 eNAWWR0/GM3UhgJSQNBmo3forCYVrdQKRNF+fPtSj9kOh1+ljSQOYnBpxet63Kw8Bf
	 GBx3KWytFqBo+nBtwU77jZI0bW72uOmwifFCHKtVrkjECvh0QMWSoqFb9MaM6+izqG
	 6rin6gy13+vqHMniez8ytADE32fn03PliQJxT3bjmatIW5rWQwNaNVGhDSYMMvZqB2
	 cHQacOXnWEYJQ==
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
Subject: [PATCH 12/14] objtool: Reuse consecutive string references
Date: Wed,  4 Mar 2026 19:31:31 -0800
Message-ID: <1cdd2737d2db5a300eea971382c5e8edda7fb474.1772681234.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772681234.git.jpoimboe@kernel.org>
References: <cover.1772681234.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2B28120A8A9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2120-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

For duplicate strings, elf_add_string() just blindly adds duplicates.

That can be a problem for arm64 which often uses two consecutive
instructions (and corresponding relocations) to put an address into a
register, like:

  d8:   90000001        adrp    x1, 0 <meminfo_proc_show>       d8: R_AARCH64_ADR_PREL_PG_HI21  .rodata.meminfo_proc_show.str1.8
  dc:   91000021        add     x1, x1, #0x0    dc: R_AARCH64_ADD_ABS_LO12_NC   .rodata.meminfo_proc_show.str1.8

Referencing two different string addresses in the adrp+add pair can
result in a corrupt string addresses.  Detect such consecutive reuses
and force them to use the same string.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 3da90686350d..52ef991115fc 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -1321,6 +1321,8 @@ struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name)
 
 unsigned int elf_add_string(struct elf *elf, struct section *strtab, const char *str)
 {
+	static unsigned int last_off;
+	static const char *last_str;
 	unsigned int offset;
 
 	if (!strtab)
@@ -1329,17 +1331,22 @@ unsigned int elf_add_string(struct elf *elf, struct section *strtab, const char
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
 	offset = ALIGN(strtab->sh.sh_size, strtab->sh.sh_addralign);
 
 	if (!elf_add_data(elf, strtab, str, strlen(str) + 1))
 		return -1;
 
+	last_str = str;
+	last_off = offset;
+
 	return offset;
 }
 
-- 
2.53.0


