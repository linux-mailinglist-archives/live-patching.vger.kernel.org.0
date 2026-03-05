Return-Path: <live-patching+bounces-2141-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WF9NFK0OqmngKQEAu9opvQ
	(envelope-from <live-patching+bounces-2141-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 00:15:57 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E62BD21936B
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 00:15:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A09A4301FD50
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 23:15:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF20364EAC;
	Thu,  5 Mar 2026 23:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jd1Giw+W"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD59283FC3
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 23:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772752555; cv=none; b=TpfrehZRW5fRbUPRc/SH3GxDaLax2lR9rhqrMlPpv7fhxVfmyAJ5eGPmi0uYA/ke2+xg7dFH4d4djorhdUk2Lv8fX5bcozWpf9qXYmclRhQNtnpV/Pw9VKqUym6fvPmD4X4rVOUbSyJL9GHrXcfXx2W3GT/1x9aAj/CMxk0gkCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772752555; c=relaxed/simple;
	bh=mtmHoRukU6cHqVWnwy02UJRMpnb4xWGhB+BmPtGM5Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmak9mkly8DsV10o1R6Yzv9o9WYp+H4XTCiSB50eF5QQYw5108X+0tAF/TZEBmmedXMvOOlWZfGXM38zhA6Eac38mJ78TBGRO0a5lsZmQiqAW/ezJ6Owo6CbjEotsv41BRoIfN3E5nd+hJbo/R5Lpm/DztzVU7taeQGaKH6z1rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jd1Giw+W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA06C19423;
	Thu,  5 Mar 2026 23:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772752554;
	bh=mtmHoRukU6cHqVWnwy02UJRMpnb4xWGhB+BmPtGM5Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jd1Giw+W6td0j7voMDGxqSRptP3WjlPTrrmLo+KVwyJ/bJ5P7TuYKumyFMty3zqBC
	 AmovJX3x2iASczvmnO3MI2GJmY60adfyBqXiltv291kSvF+yV9ntMvxdbq3wCjPWEt
	 rNhWdVl6b6FT45ECWCOXfbuF/eWSin4lGA2i1yxar85Fj2q1fRuUsFxCVmI/EHMeoo
	 CVkpAjRu5jEleFq/IeavUz2sNahhO53cHy4OGKQkm0Sk+nmpLvD32qe5DTXCC7Pm6P
	 D/c3myIaJsmNYXX22I4OzCLFdsmRmKydZeOjKewYAF2cpjKhFS5SB28SEBPRB3De8h
	 RIcnaqd4Tdf6A==
From: Song Liu <song@kernel.org>
To: live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	kernel-team@meta.com,
	Song Liu <song@kernel.org>
Subject: [PATCH v4 4/7] objtool/klp: Also demangle global objects
Date: Thu,  5 Mar 2026 15:15:28 -0800
Message-ID: <20260305231531.3847295-5-song@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260305231531.3847295-1-song@kernel.org>
References: <20260305231531.3847295-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E62BD21936B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2141-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

With CONFIG_LTO_CLANG_THIN, it is possible to have global __UNIQUE_ID,
such as:

   FUNC    GLOBAL HIDDEN  19745 __UNIQUE_ID_quirk_amd_nb_node_458

Also demangle global objects.

Signed-off-by: Song Liu <song@kernel.org>
---
 tools/objtool/elf.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index d9f883f7cff8..78db51ebbed4 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -488,9 +488,6 @@ static const char *demangle_name(struct symbol *sym)
 	char *str;
 	ssize_t len;
 
-	if (!is_local_sym(sym))
-		return sym->name;
-
 	if (!is_func_sym(sym) && !is_object_sym(sym))
 		return sym->name;
 
-- 
2.52.0


