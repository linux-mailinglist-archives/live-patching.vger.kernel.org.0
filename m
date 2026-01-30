Return-Path: <live-patching+bounces-1931-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EIN5DLDxfGndPQIAu9opvQ
	(envelope-from <live-patching+bounces-1931-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 19:00:16 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C222ABD8F0
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 19:00:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 24097300A74D
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 18:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7F28342C98;
	Fri, 30 Jan 2026 18:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hrvULok3"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39ED42874E9
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 18:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769796009; cv=none; b=LJnqUTHM5oYtysQlYGFlxeYlxkbfCI6Amaaq0CQy3T/8P8iRa2xOjB+n2RGAGXhTl4XddmSmU0P54v820MrNZm5+kNai6+f1PyykboET5pEc765evOUwe6gtYZJSI2pBS3a29X/uToYOPLqZ42vki8065ixX3plEGX7ZGwRsut0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769796009; c=relaxed/simple;
	bh=hN/MMf+vAZ1S/CZjsEx2vXtzFTIk+tbC8eh35QLJWK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=JcBBF2UgolZ4nP3oV5W51Htr5/f9zAu62geHgM4BKeXnVaxvQ2vVYMU2YVfna6OF6+lcMRv7qwfiGEd+8yTIQwAHw50ZEtWcRy9xMJ/XWFxY/6sFHPAMyWscQvkWsYTI3lG9/S8DJT0S/9sZ7oulh/O1c8LATHagmdD/4pv6fVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hrvULok3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769796007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vGXH88fM3lYvZvHZ/8xjqzU1YqixZmiCIQSh0zKHkbY=;
	b=hrvULok33xDIuy7ZlmDUGcq0CYTHEWGRCHoWQEIzvqdlCImN1FB5YAFZcMG3kMBU8LbzD4
	KWDPOgC3660rnvtnxpi7+NXGeT4oIPzPn9VwpnoO7Y3DXyOA7u4r2riOJm3/cz1bY8n9u+
	WRU8jVZEu0lGNvxriW0bzkj5s3OiK7s=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-404-8KoPO2LdMZyiLk3rYhwRHg-1; Fri,
 30 Jan 2026 13:00:05 -0500
X-MC-Unique: 8KoPO2LdMZyiLk3rYhwRHg-1
X-Mimecast-MFC-AGG-ID: 8KoPO2LdMZyiLk3rYhwRHg_1769796004
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0201C1955F2D;
	Fri, 30 Jan 2026 18:00:04 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.81.18])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EB5041800995;
	Fri, 30 Jan 2026 18:00:01 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH 2/5] objtool/klp: handle patches that add new files
Date: Fri, 30 Jan 2026 12:59:47 -0500
Message-ID: <20260130175950.1056961-3-joe.lawrence@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1931-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C222ABD8F0
X-Rspamd-Action: no action

The klp-build script prepares a clean patch by populating two temporary
directories ('a' and 'b') with source files and diffing the result.
However, this process currently fails when a patch introduces a new
source file as the script attempts to copy files that do not yet exist
in the original source tree.

Update the file-copying logic in refresh_patch() to verify existence
before processing:

- Filter the files list to ensure only files currently present in $SRC
  are copied to the 'a' directory.
- Apply the patch, then verify file existence again before copying
  to the 'b' directory.
- Ignore "/dev/null" entries, which represent non-existent files in
  patch headers.

This allows klp-build to successfully process patches that add new
source files to the kernel.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/klp-build | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

This problem was found with a simple patch that included a new header
file:

  diff --git a/fs/proc/cmdline.c b/fs/proc/cmdline.c
  index a6f76121955f..d1927ad00bb3 100644
  --- a/fs/proc/cmdline.c
  +++ b/fs/proc/cmdline.c
  @@ -4,11 +4,11 @@
   #include <linux/proc_fs.h>
   #include <linux/seq_file.h>
   #include "internal.h"
  +#include "test.h"
   
   static int cmdline_proc_show(struct seq_file *m, void *v)
   {
  -       seq_puts(m, saved_command_line);
  -       seq_putc(m, '\n');
  +       seq_printf(m, test_string, saved_command_line);
          return 0;
   }
   
  diff --git a/fs/proc/test.h b/fs/proc/test.h
  new file mode 100644
  index 000000000000..94de7114cf86
  --- /dev/null
  +++ b/fs/proc/test.h
  @@ -0,0 +1 @@
  +#define test_string "%s klp=1\n"

And the build failure:

  $ ./scripts/livepatch/klp-build /tmp/new-file-test.patch
  Validating patch(es)
  error: dev/null: does not exist and --remove not passed
  fatal: Unable to process path dev/null
  error: klp-build: line 315: 'git update-index -q --refresh -- "${files[@]}"'
  error: klp-build: line 316: '( cd "$SRC"; git update-index -q --refresh -- "${files[@]}" )'
  error: fs/proc/test.h: No such file or directory
  error: patch failed: fs/proc/cmdline.c:4
  error: fs/proc/cmdline.c: patch does not apply
  error: klp-build: line 366: 'git apply --reverse "${extra_args[@]}"'
  error: klp-build: line 367: 'echo "error: $SCRIPT: $*" 1>&2'

While I don't think the script needs to handle a patch that is trying to
add completely new compilation units (that would require Makefile
changes, generate new .o files, etc.), I do think it would be helpful to
at least support patches that add new header/included files.  For
example, a common klp-macros.h file may be helpful to mimic the old
kpatch-build kpatch-macros.h, collect shadow variable IDs, etc.

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index 964f9ed5ee1b..5a8c592c4c15 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -426,6 +426,8 @@ refresh_patch() {
 	local patch="$1"
 	local tmpdir="$PATCH_TMP_DIR"
 	local files=()
+	local orig_files=()
+	local patched_files=()
 
 	rm -rf "$tmpdir"
 	mkdir -p "$tmpdir/a"
@@ -434,12 +436,20 @@ refresh_patch() {
 	# Get all source files affected by the patch
 	get_patch_files "$patch" | mapfile -t files
 
-	# Copy orig source files to 'a'
-	( cd "$SRC" && echo "${files[@]}" | xargs cp --parents --target-directory="$tmpdir/a" )
+	# Copy orig source files to 'a', filter to only existing files
+	for file in "${files[@]}"; do
+		[[ "$file" != "dev/null" ]] && [[ -f "$SRC/$file" ]] && orig_files+=("$file")
+	done
+	( cd "$SRC" && echo "${orig_files[@]}" | xargs cp --parents --target-directory="$tmpdir/a" )
 
-	# Copy patched source files to 'b'
+	# Copy patched source files to 'b', filter to only existing
+	# files after patch application
 	apply_patch "$patch" --recount
-	( cd "$SRC" && echo "${files[@]}" | xargs cp --parents --target-directory="$tmpdir/b" )
+	for file in "${files[@]}"; do
+		[[ "$file" != "dev/null" ]] && [[ -f "$SRC/$file" ]] && patched_files+=("$file")
+	done
+	( cd "$SRC" && echo "${patched_files[@]}" | xargs cp --parents --target-directory="$tmpdir/b" )
+
 	revert_patch "$patch" --recount
 
 	# Diff 'a' and 'b' to make a clean patch
-- 
2.52.0


