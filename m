Return-Path: <live-patching+bounces-1924-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WFcMJln/d2lqnAEAu9opvQ
	(envelope-from <live-patching+bounces-1924-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 27 Jan 2026 00:57:13 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 202AA8E5DB
	for <lists+live-patching@lfdr.de>; Tue, 27 Jan 2026 00:57:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EDED030265B0
	for <lists+live-patching@lfdr.de>; Mon, 26 Jan 2026 23:56:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6DB8312832;
	Mon, 26 Jan 2026 23:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ru0z142Z"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48CD312821;
	Mon, 26 Jan 2026 23:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769471814; cv=none; b=ev8iGidN03IfOmg8qluyd6cLW5a5UPCPC+pBeMM2FmexOsWqxiO1FbfXhSZHzxUlH0Xezup45NCO6kdn5dYRpeFJxXBd2SEpNnPs2K3b6F08V7CAfABfNSH7PdGF0sbQVfQVBcvRUBppsOEGkoB/QXsbpffTF4Ndq6ppzGG/2oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769471814; c=relaxed/simple;
	bh=NXApr5KNg4OuK6Xci0SZbdbOL7udGKCix6UbbIxxYOo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BEt1WjJaJts9Rt0zgGUUBqwr50z9DYmb4JMUKghhbckPNX1NMS23Gd/c4vdmanzBtY454TH/ko5YDMx3EVXU6tsfEIcrGn8HMefLcdigwgeEw8eLQmnCHVkMPNO1pJ7FcrQ0+4AubbagV1qgDnFz0229i8NKzJQzEkN3iAbkEkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ru0z142Z; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B91C2BC87;
	Mon, 26 Jan 2026 23:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769471814;
	bh=NXApr5KNg4OuK6Xci0SZbdbOL7udGKCix6UbbIxxYOo=;
	h=From:To:Cc:Subject:Date:From;
	b=Ru0z142ZUx5T9muKsSDTkuuwV+soSbWFKOekRPTf/eNOwcfV1a6YaF0FtVJPB30qi
	 bhagpJKyOa1b8GGNpXDWB9Bg2T5C6TwRWKIBAd9hP2u9ER6GJAG75cZC0sLEfafpff
	 gKy2s45OEJqwF6lmf9C93A1p7kxgN8k60TWgpXqNpuOVYTe9hZaBeOTAGwJ5hqeAty
	 uUdchmIOjtjbg/b61WCrUR6mIOaRp5nbbLbJF1SKQWPLZPwu4F+i7lY8OOwpnCItt1
	 qxHeWzTc36iSmN8KKZHxZJmOKQpTpgYHBkFA9zR0z0VJKuD0+GMfw+Mlp2v3dh2aai
	 VoyExdIxp5ETg==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Breno Leitao <leitao@debian.org>,
	Puranjay Mohan <puranjay@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Song Liu <song@kernel.org>
Subject: [PATCH] livepatch/klp-build: Fix klp-build vs CONFIG_MODULE_SRCVERSION_ALL
Date: Mon, 26 Jan 2026 15:56:44 -0800
Message-ID: <c41b6629e02775e4c1015259aa36065b3fe2f0f3.1769471792.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1924-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 202AA8E5DB
X-Rspamd-Action: no action

When building a patch to a single-file kernel module with
CONFIG_MODULE_SRCVERSION_ALL enabled, the klp-build module link fails in
modpost:

  Diffing objects
  drivers/md/raid0.o: changed function: raid0_run
  Building patch module: livepatch-0001-patch-raid0_run.ko
  drivers/md/raid0.c: No such file or directory
  ...

The problem here is that klp-build copied drivers/md/.raid0.o.cmd to the
module build directory, but it didn't also copy over the input source
file listed in the .cmd file:

  source_drivers/md/raid0.o := drivers/md/raid0.c

So modpost dies due to the missing .c file which is needed for
calculating checksums for CONFIG_MODULE_SRCVERSION_ALL.

Instead of copying the original .cmd file, just create an empty one.
Modpost only requires that it exists.  The original object's build
dependencies are irrelevant for the frankenobjects used by klp-build.

Fixes: 24ebfcd65a87 ("livepatch/klp-build: Introduce klp-build script for generating livepatch modules")
Reported-by: Song Liu <song@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 scripts/livepatch/klp-build | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 882272120c9e..a73515a82272 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -555,13 +555,11 @@ copy_orig_objects() {
 		local file_dir="$(dirname "$file")"
 		local orig_file="$ORIG_DIR/$rel_file"
 		local orig_dir="$(dirname "$orig_file")"
-		local cmd_file="$file_dir/.$(basename "$file").cmd"
 
 		[[ ! -f "$file" ]] && die "missing $(basename "$file") for $_file"
 
 		mkdir -p "$orig_dir"
 		cp -f "$file" "$orig_dir"
-		[[ -e "$cmd_file" ]] && cp -f "$cmd_file" "$orig_dir"
 	done
 	xtrace_restore
 
@@ -740,15 +738,17 @@ build_patch_module() {
 		local orig_dir="$(dirname "$orig_file")"
 		local kmod_file="$KMOD_DIR/$rel_file"
 		local kmod_dir="$(dirname "$kmod_file")"
-		local cmd_file="$orig_dir/.$(basename "$file").cmd"
+		local cmd_file="$kmod_dir/.$(basename "$file").cmd"
 
 		mkdir -p "$kmod_dir"
 		cp -f "$file" "$kmod_dir"
-		[[ -e "$cmd_file" ]] && cp -f "$cmd_file" "$kmod_dir"
 
 		# Tell kbuild this is a prebuilt object
 		cp -f "$file" "${kmod_file}_shipped"
 
+		# Make modpost happy
+		touch "$cmd_file"
+
 		echo -n " $rel_file" >> "$makefile"
 	done
 
-- 
2.52.0


