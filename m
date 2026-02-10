Return-Path: <live-patching+bounces-2001-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id TCL3BSaoi2kqYAAAu9opvQ
	(envelope-from <live-patching+bounces-2001-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Feb 2026 22:50:30 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E89C11F89C
	for <lists+live-patching@lfdr.de>; Tue, 10 Feb 2026 22:50:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5570C304D1D0
	for <lists+live-patching@lfdr.de>; Tue, 10 Feb 2026 21:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65DE333064A;
	Tue, 10 Feb 2026 21:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sW8nUpb7"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412F21C5D5E;
	Tue, 10 Feb 2026 21:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770760225; cv=none; b=SszyY79vtwCZQmZlCKDs+z+iniQS/UVi3xt2rFF+vCTlnHMtBVLVdr5ByffUN7irehLMvy6FA0eUcqqICBcjkPP2Glrtxrk/PIJrQ83+Fb3yUi47IE57gPeaoFwJPg99yQVTRn39oRyMOdf2w65TRwBnhor3iFkK4Nyk3qzHVis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770760225; c=relaxed/simple;
	bh=Rdl9Xx1R9Pp1vUsWsZm6kQj1tNqsiodXWG0UZa+dXPI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hdIwLYENd9ctPhhZ6cM94GG2Oc3njlhDa7rjhXIMcPp/EKfzaob0dw64XfmVyhT88SQoKEawjPlRUg0vMI4KWkxvc56PFpV/k7bwKP2DIjyQV7CwRAvui31tyvO+zoJFxKnmTS9P5JgqRZbJ0CZPvq8LmJ0iEmqTQP1aANly4JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sW8nUpb7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953DAC116C6;
	Tue, 10 Feb 2026 21:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770760224;
	bh=Rdl9Xx1R9Pp1vUsWsZm6kQj1tNqsiodXWG0UZa+dXPI=;
	h=From:To:Cc:Subject:Date:From;
	b=sW8nUpb7WqEv3QbgW0VUdjW4DSQfcwdWfRiFi9AjbmGoO9pJpnVW34296bU8fjLRp
	 sEVd4VznjLeajS9CsI2ObIey0ZCstT27R1CNIa2gx9Eb3sEgv9BPMSgm3sO1VPG3eL
	 HpPIEDbx7c/ry6eIxDYTrZuCPhjbqx9ajEWTamojnRxPPKTl5Yas9FJs7sXdS0Rvj5
	 Zurv/hjJt527MtdKDQlYuMTKp27zFGHxZpfZELqO80mv+m8JC0o6wcH/nzWpA26HZF
	 Hj+b1M0U0v2v2iVgXyuxj4Lt0a6hpoL3knsKauF4SRet6mBuJbMZ80J5GOs9M8E5Vx
	 PAobWW9B3i78g==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	live-patching@vger.kernel.org,
	Song Liu <song@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>
Subject: [PATCH 0/3] objtool/klp: Special section validation fixes
Date: Tue, 10 Feb 2026 13:50:08 -0800
Message-ID: <cover.1770759954.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2001-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	PRECEDENCE_BULK(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6E89C11F89C
X-Rspamd-Action: no action

Fix some issues in validate_special_section_klp_reloc().

Josh Poimboeuf (3):
  objtool/klp: Fix detection of corrupt static branch/call entries
  objtool/klp: Disable unsupported pr_debug() usage
  objtool/klp: Avoid NULL pointer dereference when printing code symbol
    name

 tools/objtool/klp-diff.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

-- 
2.53.0


