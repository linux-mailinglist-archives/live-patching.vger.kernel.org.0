Return-Path: <live-patching+bounces-1930-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6DrWAa/xfGndPQIAu9opvQ
	(envelope-from <live-patching+bounces-1930-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 19:00:15 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 47C9FBD8E9
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 19:00:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 377B83007E30
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 18:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88EB6369961;
	Fri, 30 Jan 2026 18:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tw7XLJcO"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A2D369222
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 18:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769796007; cv=none; b=ltN5jC40yCWmuPCdGnJ6cahXV7IGn95RwRVpHKBmjSzvbK4v3UpGNQvUKckE7xHGo6Y/0412ZuGIX1cnXrJaDwQ1iSRInUz73n8w2NzBBltAmUroeDXZaaOhsHZ4GAkHS+Y7HXG/yf8rOebTg0pfADrvi75c6nv60B4xg2urspY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769796007; c=relaxed/simple;
	bh=2+U5GvE313dNelVdURbCRih+eFvDFiagP2Q2HKu0ZuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=RaoO/v5prhBiu6zXV1hKVwdmmfa65H7HZkHiUrcfJLtr+5kCntt3h7Z2dliLqbuNTMx2dLWZdhjpNUmFRKExZWoPaTtbFAM252mPbsr4/uOlAQGn/BM2m9EZYXRakd+XxWRJF2bm7jUzRxgnrTailKR7eRmDt1jnO/ygBfz/IF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tw7XLJcO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769796005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sY8Rf+RLGZiCJqduddHZGbA621Aq0r5KGWIkYIfkDIw=;
	b=Tw7XLJcO20sRLulMOm30BgHQe49G82MIV701YjIm+uBUHBgG0spAgiVbjnOGmmhMzowS3x
	/P2uPqDI2EMNRmIE867MEtkm3ewjuAUGGRWgwPbJaUnNtTs9Kk5MgVr391mOttpUHSwmrs
	0+FKpykcO2cOxMd27dDGNldFFka9LSk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-25-WZp20Bo4MLysDBzvLGVuTg-1; Fri,
 30 Jan 2026 13:00:02 -0500
X-MC-Unique: WZp20Bo4MLysDBzvLGVuTg-1
X-Mimecast-MFC-AGG-ID: WZp20Bo4MLysDBzvLGVuTg_1769796001
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB3BD195608F;
	Fri, 30 Jan 2026 18:00:01 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.81.18])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5BBFA18007D2;
	Fri, 30 Jan 2026 18:00:00 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 1/5] objtool/klp: limit parent .git directory search
Date: Fri, 30 Jan 2026 12:59:46 -0500
Message-ID: <20260130175950.1056961-2-joe.lawrence@redhat.com>
In-Reply-To: <20260130175950.1056961-1-joe.lawrence@redhat.com>
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1930-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[git-scm.com:url,raw.githubusercontent.com:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 47C9FBD8E9
X-Rspamd-Action: no action

When klp-build runs git commands, they may search upwards for a .git/
directory if one isn't found in the current $SRC path. This can lead to
unexpected behavior if the kernel source is nested within another git
tree.

Set and export GIT_CEILING_DIRECTORIES to the parent of $SRC to restrict
git lookups to the local kernel tree only. This ensures that git
operations remain consistent and prevents picking up repository state
from parent directories.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/klp-build | 3 +++
 1 file changed, 3 insertions(+)

I encountered this failure mode when running klp-build out of a kernel
source rpm extraction inside a testing git repo tree.  In this case,
there is no <kernel_dir>/.git, but there is one further up the directory
hierarchy.  This confuses the script when it tries to fixup the patch as
git commands will keep looking for a .git in parent directories unless
otherwise bounded [1].

Here's a quick repo:

  $ cd /tmp
  $ mkdir test_dir
  $ cd test_dir

  # Force a /tmp/test_dir/.git
  $ git init

  $ git clone --depth=1 --branch=v6.19-rc4 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
  $ cd linux

  $ wget https://raw.githubusercontent.com/dynup/kpatch/refs/heads/master/examples/cmdline-string.patch

  # Basic config for livepatching ...
  $ make -j$(nproc) defconfig
  $ ./scripts/config --file .config \
      --set-val CONFIG_FTRACE y \
      --set-val CONFIG_KALLSYMS_ALL y \
      --set-val CONFIG_FUNCTION_TRACER y \
      --set-val CONFIG_DYNAMIC_FTRACE y \
      --set-val CONFIG_DYNAMIC_DEBUG y \
      --set-val CONFIG_LIVEPATCH y
  $ make olddefconfig

  # GOOD BUILD
  $ ./scripts/livepatch/klp-build -T cmdline-string.patch
  Validating patch(es)
  Building original kernel
  Copying original object files
  Fixing patch(es)
  Building patched kernel
  Copying patched object files
  Diffing objects
  vmlinux.o: changed function: cmdline_proc_show
  Building patch module: livepatch-cmdline-string.ko
  SUCCESS

  # BAD BUILD - remove .git/ to simulate rpm/tarball
  $ rm -rf .git
  $ ./scripts/livepatch/klp-build -T cmdline-string.patch
  Validating patch(es)
  Building original kernel
  Copying original object files
  Fixing patch(es)
  error: No valid patches in input (allow with "--allow-empty")
  error: klp-build: line 350: 'git apply "${extra_args[@]}"'
  error: klp-build: line 351: '( cd "$SRC"; sed -n '/^-- /q;p' "$patch" | git apply "${extra_args[@]}" )'

[1] https://git-scm.com/book/be/v2/Git-Internals-Environment-Variables#:~:text=GIT_DIR%20is%20the%20location,your%20shell%20prompt.

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 882272120c9e..964f9ed5ee1b 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -52,6 +52,9 @@ PATCH_TMP_DIR="$TMP_DIR/tmp"
 
 KLP_DIFF_LOG="$DIFF_DIR/diff.log"
 
+# Restrict Git repository lookup to the local $SRC path
+export GIT_CEILING_DIRECTORIES="$(dirname "$SRC")"
+
 grep0() {
 	command grep "$@" || true
 }
-- 
2.52.0


