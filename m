Return-Path: <live-patching+bounces-2639-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KHUUKxgo9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2639-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:12:08 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2856B4AA188
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:12:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 48C2F306F912
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:09:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A643E33B6CC;
	Fri,  1 May 2026 04:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oeedLMQF"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813433033E8;
	Fri,  1 May 2026 04:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608540; cv=none; b=dh905Z9RxH6DRGykWpUgMJEGpP1bF+E9b0M6U0z6AFkqUUZ6eT+tn6TP6GM48pvCJPh4bd88jSUsr7HZX1gcqLbnbi1b3nXT7Ec2VDhATD3WeL8/0j4NsfoSy+2e+hsl3cltj4BrzKUxANa/lOZoFDlWLhJxdiZq4jcMWC6TEuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608540; c=relaxed/simple;
	bh=djxbbA8QTsmn6CedczZq3P920XHpKxKsJKFDjpZyrgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2RY2AgY8lWApRcwUmP2gN9lEgsieGDqc1vT9PuQ564aHdpEOLOUdED6BUWXMU/+g5RLesWzh7uJji/Ixo24qLA0Ow930jJegPwLl9JWcUNiVw6lTr530xafRXyR8W9p8z+t+rqlZR3XJad3TnyJZLy/fIbtivWZiSGCeTR6vDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oeedLMQF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2897C2BCB7;
	Fri,  1 May 2026 04:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608540;
	bh=djxbbA8QTsmn6CedczZq3P920XHpKxKsJKFDjpZyrgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oeedLMQFmWJ5XIKZTbUrWn54rHpj3Qjh9QQigos1uIXo/Ts1RTp0lHvQ7u7lksK0/
	 y8DmCPVIMcmdiJh25unk8wLhrDkEkp99zyLBQwcm/C34GBPqo/rnwZEHyXV6FmMc7J
	 wEvJFay8SudfddBF4qqx2U16Jd+SbEpazOc6HMiUkqN0BuqDV8BdmKKGA+4egz++S0
	 l3l2tEGgEnwrCfr1QvGnGMds5xV7ZnrxEjORFbL3ESXjMhMh7INwZJEE3DQFuk41G4
	 k7t+q89wmZp9mj8Cn88Sz6N/jFc0FTbuHKmgKnepZfPhp6ocp0vE8IPXT8OLptsNcC
	 naEZCXOBtnZyQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 21/53] objtool/klp: Fix reloc corruption in convert_reloc_sym_to_secsym()
Date: Thu, 30 Apr 2026 21:08:09 -0700
Message-ID: <9b419d82a20dbc54be4a59cfec04ab13987a2e6c.1777575752.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2856B4AA188
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2639-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

Use the section symbol's index instead of the old symbol's index when
updating the ELF relocation entry in convert_reloc_sym_to_secsym().

Found by Sashiko review.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/klp-diff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index ca87bcb9afa3..463b6daa5234 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -975,7 +975,7 @@ static int convert_reloc_sym_to_secsym(struct elf *elf, struct reloc *reloc)
 		return -1;
 
 	reloc->sym = sec->sym;
-	set_reloc_sym(elf, reloc, sym->idx);
+	set_reloc_sym(elf, reloc, sec->sym->idx);
 	set_reloc_addend(elf, reloc, sym->offset + reloc_addend(reloc));
 	return 0;
 }
-- 
2.53.0


