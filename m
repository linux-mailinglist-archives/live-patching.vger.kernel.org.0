Return-Path: <live-patching+bounces-2651-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GMtuHOEo9GkH+wEAu9opvQ
	(envelope-from <live-patching+bounces-2651-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:15:29 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 112F64AA2B2
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 06:15:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 367D73096DA7
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 04:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80EFA35BDCE;
	Fri,  1 May 2026 04:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RWkI7Jek"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C57E35A3A4;
	Fri,  1 May 2026 04:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777608546; cv=none; b=g9pSgg3ZiWZudf72bzMhqWcTaFyuYap9Ytx6OgLrglwdx9ShwacQfrjHcUIZrLlEEssjJHqb0ud16+MoWAbkVZ8BUK5eyhmHFAaqKNVPCDn2tol8V/Gsd1SLfvwYdVddySXROZZYE+mnlgrkCqcm++WCSUtqIdapzUo1inebfvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777608546; c=relaxed/simple;
	bh=C6mO2sC+0qw428snku2YR7T+dAtQsZg8AqyYSoy1FIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6IyU5qtfHANlZ7nqdqVb1uKDO8kXVibzGvpWLq+D7mV0gEtNm9gO/wpQ+keJ4WtCcHA/Snyp1hh0H5RO/io9kXw38lgeMz+7nKtdd+2ECVIq8W5e6zSgpnbogob0sW+UiqjNGFaBFdWDgAFa/AYF6gWH+gzeQKCf0DHQQg64Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RWkI7Jek; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED1EC2BCB7;
	Fri,  1 May 2026 04:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777608546;
	bh=C6mO2sC+0qw428snku2YR7T+dAtQsZg8AqyYSoy1FIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWkI7JekK6w7HBId1kcBSSczIfSuBPiEIvZUGBdXzkUh3FoeAixrCb70EDsQulMxo
	 H/mJfxwh53xszMVPjDEze+wp4f+DD7PlHFHJ+biT/LIOTDWG+2FnNlUNV9T5Idk8N9
	 FWXqZN3Y2ZZ1AODfhZx+aNIPH4bWAm46tojLSjiDidsJt/liznKHM3MJhEqbdpPeZC
	 mcTu3ATxbAnuIkAXO/3V+IRsEMe+oKhrbLBZRKcitoB7nCJQCwJbkK7+afhhkqHCUq
	 bn0WoWeICnnHl79OSq6XuuJwNe3GjhJXhLDDx7wIpYR/4lMwENAYJolm0xr6XT5f34
	 TUk6QI3D/T9Bg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v2 34/53] objtool: Include libsubcmd headers directly from source tree
Date: Thu, 30 Apr 2026 21:08:22 -0700
Message-ID: <9582e7b77cb498a490bab6b93c1b330525f1a5c8.1777575752.git.jpoimboe@kernel.org>
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
X-Rspamd-Queue-Id: 112F64AA2B2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2651-lists,live-patching=lfdr.de];
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

Instead of installing libsubcmd headers to a build output directory and
including from there, include directly from tools/lib/ where they
already exist.  This fixes clangd indexing which otherwise can't find
libsubcmd headers.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index b71d1886022e..a4484fd22a96 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -58,7 +58,7 @@ INCLUDES := -I$(srctree)/tools/include \
 	    -I$(srctree)/tools/arch/$(SRCARCH)/include	\
 	    -I$(srctree)/tools/objtool/include \
 	    -I$(srctree)/tools/objtool/arch/$(SRCARCH)/include \
-	    -I$(LIBSUBCMD_OUTPUT)/include
+	    -I$(srctree)/tools/lib
 
 OBJTOOL_CFLAGS  := -std=gnu11 -fomit-frame-pointer -O2 -g $(WARNINGS)	\
 		   $(INCLUDES) $(LIBELF_FLAGS) $(LIBXXHASH_CFLAGS) $(HOSTCFLAGS)
@@ -135,7 +135,7 @@ $(LIBSUBCMD): fixdep $(LIBSUBCMD_OUTPUT) FORCE
 	$(Q)$(MAKE) -C $(LIBSUBCMD_DIR) O=$(LIBSUBCMD_OUTPUT) \
 		DESTDIR=$(LIBSUBCMD_OUTPUT) prefix= subdir= \
 		$(HOST_OVERRIDES) EXTRA_CFLAGS="$(OBJTOOL_CFLAGS)" \
-		$@ install_headers
+		$@
 
 $(LIBSUBCMD)-clean:
 	$(call QUIET_CLEAN, libsubcmd)
-- 
2.53.0


