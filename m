Return-Path: <live-patching+bounces-1933-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EBOeArPxfGndPQIAu9opvQ
	(envelope-from <live-patching+bounces-1933-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 19:00:19 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A5EB5BD8FF
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 19:00:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C760730086FF
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 18:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 628572D481F;
	Fri, 30 Jan 2026 18:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e5ETEI8g"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE11734EF0C
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 18:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769796013; cv=none; b=KPk7goC+uNdIRUcH3TvNyB27UKsHSTyJ3WTkcaEA48N27R/Xwkqh5WlAC8zmGSEiE3biLrs5sUepKwvHjbSKjF8Bd4DZOISyFgwnm4p4RNPDKiGw8Tinq9e5V/55J8USPV/FKShtoSMg5buc2JZpVorkaYTHyyrGr3BSe+SCW3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769796013; c=relaxed/simple;
	bh=V/L8BxzkJCt41PQcrHN6TvYTcU69wX8hMeceKuOKAws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RJxfLqhTmeuHAVzJ/pqyeSpVrrxTGHwW2pYoW1nMP5rutXhpoUwLntCI5jNwPZ2NeBmCf/BdyEeXUH35ujzWKx9nBNl02D8a+a9z0SxUM9sqwp+qzUsw7NLJm97uw3U/mgV5NiLfG7vERufZuARPq5nzRcTpioGZ67DyuqfnyCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e5ETEI8g; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769796010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A0EQdqFLnWSFJIsN6A/MwEbI1nF18a0Xg2igM+II4I4=;
	b=e5ETEI8gk8hpIT0elef/I5uohbGXO8PE2njql3jfmdhbvkI0LcEkIBxynBkGM9Aa0BOCls
	/Mt/iJDjurMDAabl2qL5IA3z+PmHOyIf5M0Rn7Jk8xLXHM/2RMq6pXKuuQfwYv3KnluDZC
	H65zh25WZr8DjzyHoe2eHlxq3Ui0BCI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-80-SFwdQdsxMV-_Ct0cWkWM4w-1; Fri,
 30 Jan 2026 13:00:06 -0500
X-MC-Unique: SFwdQdsxMV-_Ct0cWkWM4w-1
X-Mimecast-MFC-AGG-ID: SFwdQdsxMV-_Ct0cWkWM4w_1769796005
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B46E1956070;
	Fri, 30 Jan 2026 18:00:05 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.81.18])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4C8F41800665;
	Fri, 30 Jan 2026 18:00:04 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 3/5] objtool/klp: validate patches with git apply --recount
Date: Fri, 30 Jan 2026 12:59:48 -0500
Message-ID: <20260130175950.1056961-4-joe.lawrence@redhat.com>
In-Reply-To: <20260130175950.1056961-1-joe.lawrence@redhat.com>
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1933-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A5EB5BD8FF
X-Rspamd-Action: no action

The klp-build script performs a sanity check on user-provided patches
using `git apply --check`.  However, this check is less strict than the
subsequent patch fixup phase, which runs `git apply --recount`.

As a result, patches with line count drift (fuzz) may pass the initial
validation but fail during fixup. Update the initial validation phase to
include the '--recount' flag.  This ensures a consistent check across
both phases and allows the script to fail fast on malformed or drifted
patches.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/klp-build | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Here are the build errors:

  $ ./scripts/livepatch/klp-build -T combined.patch 
  Validating patch(es)
  Building original kernel
  
  Copying original object files
  Fixing patch(es)
  error: patch failed: fs/proc/cmdline.c:6
  error: fs/proc/cmdline.c: patch does not apply
  error: klp-build: line 350: 'git apply "${extra_args[@]}"'
  error: klp-build: line 351: '( cd "$SRC"; sed -n '/^-- /q;p' "$patch" | git apply "${extra_args[@]}" )'

This was a strange one to debug, but I finally narrowed it down to
pecular `git apply` behavior depending on the presence of the --recount
flag.

Consider a patch offset by a line:

  $ cat combined.patch
  --- src.orig/fs/proc/cmdline.c	2022-10-24 15:41:08.858760066 -0400
  +++ src/fs/proc/cmdline.c	2022-10-24 15:41:11.698715352 -0400
  @@ -6,8 +6,7 @@
  
   static int cmdline_proc_show(struct seq_file *m, void *v)
   {
  -	seq_puts(m, saved_command_line);
  -	seq_putc(m, '\n');
  +	seq_printf(m, "%s livepatch=1\n", saved_command_line);
   	return 0;
   }
  
  --- a/fs/proc/version.c
  +++ b/fs/proc/version.c
  @@ -9,6 +9,7 @@
  
   static int version_proc_show(struct seq_file *m, void *v)
   {
  +	seq_printf(m, "livepatch ");
   	seq_printf(m, linux_proc_banner,
   		utsname()->sysname,
   		utsname()->release,

GNU patch reports the offset:

  $ patch --dry-run -p1 < combined.patch
  checking file fs/proc/cmdline.c
  Hunk #1 succeeded at 7 (offset 1 line).
  checking file fs/proc/version.c

It would pass the initial check as per validate_patches():

  $ git apply --check < combined.patch && echo "ok"
  ok

But later fail the patch application by refresh_patch():

  $ git apply --check --recount < combined.patch
  error: patch failed: fs/proc/cmdline.c:6
  error: fs/proc/cmdline.c: patch does not apply

Adding the same --recount argument to validate_patches() would allow the
script to fail fast and not (cryptically) way later:

  $ ./scripts/livepatch/klp-build -T combined.patch
  Validating patch(es)
  error: patch failed: fs/proc/cmdline.c:6
  error: fs/proc/cmdline.c: patch does not apply
  error: klp-build: combined.patch doesn't apply
  error: klp-build: line 453: '( cd "$SRC"; sed -n '/^-- /q;p' "$patch" | git apply "${extra_args[@]}" || die "$patch doesn't apply" )'

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 5a8c592c4c15..2313bc909f58 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -379,10 +379,11 @@ revert_patch() {
 }
 
 apply_patches() {
+	local extra_args=("$@")
 	local patch
 
 	for patch in "${PATCHES[@]}"; do
-		apply_patch "$patch"
+		apply_patch "$patch" "${extra_args[@]}"
 	done
 }
 
@@ -399,8 +400,8 @@ revert_patches() {
 
 validate_patches() {
 	check_unsupported_patches
-	apply_patches
-	revert_patches
+	apply_patches --recount
+	revert_patches --recount
 }
 
 do_init() {
-- 
2.52.0


