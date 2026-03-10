Return-Path: <live-patching+bounces-2178-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IM5+Hz2BsGmwjwIAu9opvQ
	(envelope-from <live-patching+bounces-2178-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 21:38:21 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BBA0257F34
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 21:38:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E0EB130EDBE9
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 20:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 765953CC9FE;
	Tue, 10 Mar 2026 20:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fe3NC3d1"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401173CA487
	for <live-patching@vger.kernel.org>; Tue, 10 Mar 2026 20:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773175099; cv=none; b=jxaJP1IShVuMupO50NcQaXN+iVCJc4Ah0wm9Oyf0WFU9zn2v+9Spsh8zf8rOPrLKV4WdmAETqta6C5wbmCUWL6yAIqsd4vTGgt5OJTxBQ4ytX9lF+Im8g+J2QqNaYDYKpx74j0EDz4nuxfBxUw5OLF/ZawitM8shHg5uhbE7leg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773175099; c=relaxed/simple;
	bh=quUl7U1PY5wpvqjxGaCiZRyIZrBOQHfLzRkP6qmO1/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=aOiM3FVOn0sOVlcp7Zj6rugR+kVukbH6zS0DQycWzkNQLt1Rv46g/+3F50fKdiOY7UErkCeJsWk7gCWCKWlsvZYCQXk+w0K6ddEpg/GLNyc1gsI1QayS/nir2NBfA/S7lTUbe0BMf5jI1DU9YzysNs0/mTChXKI3ObFGZLYsXb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fe3NC3d1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773175097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bqYvuUDDxTIc8DSdsxMVk/stZc2JLx+6/Xt47gkeW2Q=;
	b=fe3NC3d14ovEwsXLsCS933NsRacgOKFNm8tj/fuegeFJIfFePsyLEaZykkUXgQwYdH2sE1
	d9XuiLxE4FsEiwZdLRRVSal/qxXCAYBEkQBgc06aKOEWH4EiUcIYrsbmJ+k1HBNpbASaky
	a4GO4msHXBF+HgJUMTCcUpsryVzE3Hg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-592-CMwpQ7P6OFy2Yq5_UYhEBg-1; Tue,
 10 Mar 2026 16:38:15 -0400
X-MC-Unique: CMwpQ7P6OFy2Yq5_UYhEBg-1
X-Mimecast-MFC-AGG-ID: CMwpQ7P6OFy2Yq5_UYhEBg_1773175094
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5A3CE1956096;
	Tue, 10 Mar 2026 20:38:14 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.80.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0808E19560A6;
	Tue, 10 Mar 2026 20:38:12 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v4 11/12] livepatch/klp-build: add terminal color output
Date: Tue, 10 Mar 2026 16:37:50 -0400
Message-ID: <20260310203751.1479229-12-joe.lawrence@redhat.com>
In-Reply-To: <20260310203751.1479229-1-joe.lawrence@redhat.com>
References: <20260310203751.1479229-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Queue-Id: 2BBA0257F34
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
	TAGGED_FROM(0.00)[bounces-2178-lists,live-patching=lfdr.de];
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
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Improve the readability of klp-build output by implementing a basic
color scheme.  When the standard output and error are connected to a
terminal, highlight status messages in bold and warning/error prefixes
in yellow/red.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 scripts/livepatch/klp-build | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
index cf36555330b3..325dc4601bba 100755
--- a/scripts/livepatch/klp-build
+++ b/scripts/livepatch/klp-build
@@ -52,6 +52,15 @@ PATCH_TMP_DIR="$TMP_DIR/tmp"
 
 KLP_DIFF_LOG="$DIFF_DIR/diff.log"
 
+# Terminal output colors
+read -r COLOR_RESET COLOR_BOLD COLOR_ERROR COLOR_WARN <<< ""
+if [[ -t 1 && -t 2 ]]; then
+	COLOR_RESET="\033[0m"
+	COLOR_BOLD="\033[1m"
+	COLOR_ERROR="\033[0;31m"
+	COLOR_WARN="\033[0;33m"
+fi
+
 grep0() {
 	# shellcheck disable=SC2317
 	command grep "$@" || true
@@ -65,15 +74,15 @@ grep() {
 }
 
 status() {
-	echo "$*"
+	echo -e "${COLOR_BOLD}$*${COLOR_RESET}"
 }
 
 warn() {
-	echo "error: $SCRIPT: $*" >&2
+	echo -e "${COLOR_WARN}warning${COLOR_RESET}: $SCRIPT: $*" >&2
 }
 
 die() {
-	warn "$@"
+	echo -e "${COLOR_ERROR}error${COLOR_RESET}: $SCRIPT: $*" >&2
 	exit 1
 }
 
@@ -110,7 +119,7 @@ cleanup() {
 }
 
 trap_err() {
-	warn "line ${BASH_LINENO[0]}: '$BASH_COMMAND'"
+	die "line ${BASH_LINENO[0]}: '$BASH_COMMAND'"
 }
 
 trap cleanup  EXIT INT TERM HUP
-- 
2.53.0


