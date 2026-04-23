Return-Path: <live-patching+bounces-2444-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aMgNCGme6WkAfQIAu9opvQ
	(envelope-from <live-patching+bounces-2444-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:22:01 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F00F44CE79
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 06:22:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2C84E3125D30
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 04:06:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF983D6478;
	Thu, 23 Apr 2026 04:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BK2XFmxg"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC213D567C;
	Thu, 23 Apr 2026 04:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776917072; cv=none; b=WoGciyaQX6I7M0L3QD8iETHphIUUH9S4pSGJ+aKoNzR7Zm0PaL8R5hJK9txFrdzg3cmqTVPRRQ6DClILl5s5JZoSmOtp6rOmI1izjFi2ck+xdxTZDDF3mCDmTGlvahzpAUf6TZ5+xt9PanBcn7ojOrY+oPhlr8CuTlh9EM/Zvng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776917072; c=relaxed/simple;
	bh=Ty1q/fm/UXH3JfFek3GeE1KHOOhsnkTq3KM1WCeyXt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vj0KfUJ8qMCHHzJw1rTsak+Qfq7dBiYDyzvsWcYIJLMndFpLeHBT/5jbsIDsAlMeZLBpmNh9tVrxoszXt8fHwcw1V4CSx/khrHDV2cAPIaSSSYplGh0R1evvolLXoNwkq1EorFqGcPkEoZH2DuxvVK05wiANFYZ9JPUSXBuKhgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BK2XFmxg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86DFC2BCB6;
	Thu, 23 Apr 2026 04:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776917072;
	bh=Ty1q/fm/UXH3JfFek3GeE1KHOOhsnkTq3KM1WCeyXt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BK2XFmxgKUC9ZQ3pLPB3IZi/Uezxbk4X5xsY985zXVxWPd/W9cdktW8cCn7NnfZMu
	 xpanm927rX5uoL4SPSme1p/OKf4+doRK/wsa3jrIv7WHOTygPEz/yjYYCWXJQlBtDy
	 y8b/+EjEXqJx7Yg8mfERYeZkkCVTcEoXRCDCiiIEESQuA5wlhz30HW1UPyvdBR1erW
	 vYewGBndqCgytyZp1gz5xFvXT1sSAjXC53aZGdAA7b4KC0u86MMRQwdpG6giL97tTj
	 n1UU0QBvcT9wgiur7IyDtnu7Qg9+OXqc7uMwvt4lCLaFcsOlUsA3OxvoxDHui1resD
	 RiKl5uMlxi2ng==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 17/48] objtool: Fix reloc hash collision in find_reloc_by_dest_range()
Date: Wed, 22 Apr 2026 21:03:45 -0700
Message-ID: <09dab1995c4ba6ca29dd70b0a7472f1a2975fefd.1776916871.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
	TAGGED_FROM(0.00)[bounces-2444-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6F00F44CE79
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

In find_reloc_by_dest_range(), hash collisions can cause a high-offset
relocation to appear when probing a low-offset hash bucket.

Only return early when the best match found so far genuinely belongs to
the current bucket (its offset is within the bucket's stride range).
Otherwise, continue scanning later buckets which may contain
lower-offset matches.

Fixes: 74b873e49d92 ("objtool: Optimize find_rela_by_dest_range()")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/elf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index a5486e172e5c..c4cb371e72b2 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -370,11 +370,11 @@ struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *se
 					r = reloc;
 			}
 		}
-		if (r)
+		if (r && (reloc_offset(r) & OFFSET_STRIDE_MASK) == o)
 			return r;
 	}
 
-	return NULL;
+	return r;
 }
 
 struct reloc *find_reloc_by_dest(const struct elf *elf, struct section *sec, unsigned long offset)
-- 
2.53.0


