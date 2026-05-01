Return-Path: <live-patching+bounces-2647-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GFUtOMAo9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2647-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:14:56 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 796264AA28D
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:14:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 05508308FA0F
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E90634FF5A;
	Fri,  1 May 2026 04:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AIiyF5wL"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE38530F958;
	Fri,  1 May 2026 04:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608545; cv=none; b=hLJvpH7Y05j0Pagyxuk26vTZHWG0zu7Z+mfP8tSJ0MF0ta9e/q+mgFRCKQhmwSljhxMbXQX/Rjnz+ZdKWfQ/MKyUs5k+/clpVhz/AOUGAXDy+FYMNdIdi06CDTTKkMzZGjqMSH40HfR6xHRKAAmoxXbAU79Y351fYUoiaYau4EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608545; c=relaxed/simple;
	bh=+cSOMoJ52+YC//3yBJ8PpJ9LJCgKreOela/CrfW2oxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umo2ke2EkJxzT0JNQkRe1h0G64TtdqQENiQsuAQxuK8cgG/yeZd6KBLGwaRJAdQK9G0XfBE/BWmYCTcZn30gWa9/O4vlzKFgpPx/ns60elJuCHfASwGmlrGkgVKZRj3IBd7I3hGNpbzmLf1SKJ7g+ohnVmFr0N+i9NLGek3GTCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AIiyF5wL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B69C2BCC6;
	Fri,  1 May 2026 04:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608544;
	bh=+cSOMoJ52+YC//3yBJ8PpJ9LJCgKreOela/CrfW2oxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIiyF5wLl+kWFlNnqB2iCf0JvENSB5fHk3EDZIf9sJpd00z+OvFgd+8qHzrhH5u5j
	 KBwIHY6zvmr0vgbpTmmzMaagM8XTtMsb8iwAthB/LA4zsWZ2ulNTUcZ5kjbFJIogxX
	 42EC1GsA+KLwvMKHtcA19tc9+rxRjp8nv1+QyLE2821U5sGVgYLtGZeIFKZPGh6xk6
	 KHNgWyGxjugVpnz0UNoR1XoyivlA2KkOuLBAnbS1GJxeaQCh7W6qv/TDgd8lPr9mke
	 XN3/R+mhgjMBrSLmwcoDeICAql4mkmRLGE/8MSoMX68/T/3ehpWg7qmh7Kdq+GlF8I
	 z17Vq4eh2BFmg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 31/53] klp-build: Print "objtool klp diff" command in verbose mode
Date: Thu, 30 Apr 2026 21:08:19 -0700
Message-ID: <949a2ff797f2c7e366dedc760aea726e7cae1b11.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: 796264AA28D
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
	TAGGED_FROM(0.00)[bounces-2647-lists,live-patching=lfdr.de];
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

Print the full objtool command line when '--verbose' is given to help
with debugging.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 2bb35de5db75..355345aa94d2 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -681,6 +681,7 @@ diff_objects() {
 
 		(
 			cd "$ORIG_DIR"
+			[[ -v VERBOSE ]] && echo "${cmd[@]}"
 			"${cmd[@]}"							\
 				1> >(tee -a "$log")					\
 				2> >(tee -a "$log" | "${filter[@]}" >&2) ||		\
-- 
2.53.0


