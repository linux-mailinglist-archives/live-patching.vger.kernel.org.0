Return-Path: <live-patching+bounces-2877-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +F30CuCOE2rbDQcAu9opvQ
	(envelope-from <live-patching+bounces-2877-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 01:50:56 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C94365C4CD7
	for <lists+live-patching@lfdr.de>; Mon, 25 May 2026 01:50:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4E7283009570
	for <lists+live-patching@lfdr.de>; Sun, 24 May 2026 23:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A7F93B83E0;
	Sun, 24 May 2026 23:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Cp+7TWTU"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8E637BE64
	for <live-patching@vger.kernel.org>; Sun, 24 May 2026 23:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779666648; cv=none; b=cxooF/BY5mWGgIgKR3kEW2m/b1pW++Mo0+pncKqXqQKE002DgbOZUzgsnynR1yXgH3+VljQ62uZ4o/s3NV8BeTKZyDbBZgWtThdpHwX7kF+DRy5jzORt6N4yGOhhb4ZDw2qtLKDNuQiD257nYShpInd+RNRFF2ZTWquDg1+WLTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779666648; c=relaxed/simple;
	bh=lrUQ+ASPU3xAum/aWZ6YpYQB/mezdh2Eah+p4RDAlFk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WnFkbJgqei6rJd08RAGniWU4wVckiqovoGsGloTePL6kuY65gdYBy48bK5nsAmQ81i78SZkb9ALHL0XW6Qnr1mxhMJvYTCsZlO7IOO8aFbe/kNMWZ6B+DAexBXWRHwFKLVSXf2gce9NN5Qu527AUHmhGaVokzFBtJ0SPdiSZHiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Cp+7TWTU; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-44509921fbcso5730258f8f.3
        for <live-patching@vger.kernel.org>; Sun, 24 May 2026 16:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779666645; x=1780271445; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WIsAnhC13Ci6OZvSY3IyfdrGYvDfHjgHhajtnryGtOQ=;
        b=Cp+7TWTUPHOVA9zL2NzFZxmvJGDbs6LdKd9ZUNWNJaDjlkJ2/CjmhMgZa0v+jNBIBc
         PQ8XJL4ZYcmqy2Oy18Vqi5mzVml+ZrIcD2Zg2zR+SftFu5FWSKti4n0OvzPAqXXjOjf3
         hScbm/WMigMJStPaZV2exCrqTq7c1liOkKAoJVWzko8lboPXVSCvChpmNXqZvvwPNJNO
         u+kkEI88i07L79j/XK3kJ42F0HJH64MwU6nu8HxEnrF1N14hQuNnbUlEOvYF45WQCdjH
         OrFsMRt5wNHcb0MpRRd2EgKZzLTWpEzdA0hS/AzLyjT6Avco0XSVzJh+PyDtFAkd+JCT
         wN3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779666645; x=1780271445;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WIsAnhC13Ci6OZvSY3IyfdrGYvDfHjgHhajtnryGtOQ=;
        b=Vk6Bd1/iV0Dlokk+aTZ2CYhXcLi/9QzsJZFB2PHj2nojkNU2JA2tVTajJI5//IJiSQ
         YW6m+FCsM9N6vBOra1Smn3RHl7oD0jHJTWl19/VGbHjUNBsi4PPTuM+72XlENXz2Gn76
         Ga41/JmhHW0wbnWw9qvxrU4UaHjtTcAOY4LIzspksX8FifjiZ/rf0hKGZFYoOcDhxFMq
         3X86v+dN1VF2mEXsBM7M7/s4oc9d5daRZywYbvm+zPh5erOCkZXTqI1KefESwyljHHc8
         NyFnCxQdVyBd5kAZ1z1Yr36Z7AEP4Ry4RXotMVXjCkU2h+TfP+NVS+VjaqXOBo0hsLmD
         2jNQ==
X-Gm-Message-State: AOJu0Yyv/nSMHPWgJVXeACTFBrn91732MLQWMpoVuLxcJXa7m1j+w379
	wEwGO0KvYRE1OCR7fzDwHiO2CHSkQPvbCl4U3mpQu/QONufysbFar3mZhrghRvn8gUM=
X-Gm-Gg: Acq92OHGFFE1D0XaxptGMNwz/aUGdynTmaPVj7M3PHOA7WaxD6ZvzJX7X/mO6PqQGnZ
	DhDsurGbx3aJ8xQd7BjnI/5nVpfXwh8ek5l3wyIyKQl2Pa5EtOvh1ZQLM9DFaLM2ik3LaVaCF4W
	on4rmO2SnBFcCrMTO2IOEYcLFprzSUbP7Qn9LlbkPdJZB9v5vWs8M3SXCYnN8ZQF/hyhPuex1xm
	7/rRvEHMK2FYHti7edvlWgfcS9QKDP4SHIE4+Q3JhkSnxpiq5kP2fqfU2lpJzlrqQMDxURc85d/
	b1d7lfe/MxUVgYHX7va70GJi31GJrsMplbtNtX+xYyGCGeoC0X5tD3IKs54gAdWIjdWxJcG7Jvc
	IXXi90I9Ij8NFPZZs8p389qkBdwOS3DJfAKlfgfy3G65UffIGonfWDiG4dka5frEB/74TSUrkri
	uzf2JhQB/lOTKXjeFJlJnzy8k=
X-Received: by 2002:a05:6000:1a87:b0:43f:e2b7:7160 with SMTP id ffacd0b85a97d-45eb3673319mr21805862f8f.4.1779666644786;
        Sun, 24 May 2026 16:50:44 -0700 (PDT)
Received: from [127.0.0.1] ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6c9de2dsm21698074f8f.4.2026.05.24.16.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 16:50:44 -0700 (PDT)
From: Marcos Paulo de Souza <mpdesouza@suse.com>
Date: Sun, 24 May 2026 20:50:30 -0300
Subject: [PATCH 1/4] selftests: livepatch: Introduce _remove_mod function
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260524-livepatch-unload-on-fail-v1-1-7465de7f741d@suse.com>
References: <20260524-livepatch-unload-on-fail-v1-0-7465de7f741d@suse.com>
In-Reply-To: <20260524-livepatch-unload-on-fail-v1-0-7465de7f741d@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Marcos Paulo de Souza <mpdesouza@suse.com>, 
 marcos@mpdesouza.com
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779666636; l=1399;
 i=mpdesouza@suse.com; s=20231031; h=from:subject:message-id;
 bh=lrUQ+ASPU3xAum/aWZ6YpYQB/mezdh2Eah+p4RDAlFk=;
 b=EYzbJCAGfZmnkCH3w3VcEoq2r+ahV3xg5Tgv81iN5gabPMRVlxE6dwmHqn2nM86vBNPXlKCsg
 yhqpacu1krLC/hwUllBDrlnA5U17sV8RlabxL9iEDKvL+T74Q/qfkzI
X-Developer-Key: i=mpdesouza@suse.com; a=ed25519;
 pk=/Ni/TsKkr69EOmdZXkp1Q/BlzDonbOBRsfPa18ySIwU=
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	TAGGED_FROM(0.00)[bounces-2877-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,suse.com:dkim,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: C94365C4CD7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This new function will be used in the next patch to remove loaded
modules when a testcase fails.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 tools/testing/selftests/livepatch/functions.sh | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 2bc50271729c..3ec0b7962fc5 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -241,9 +241,10 @@ function load_failing_mod() {
 	log "$ret"
 }
 
-# unload_mod(modname) - unload a kernel module
+# _remove_mod(modname) - Internal function to remove a loaded module.
+#                        Use unload_mod() instead, which also updates TEST_MODS tracking.
 #	modname - module name to unload
-function unload_mod() {
+function _remove_mod() {
 	local mod="$1"
 
 	# Wait for module reference count to clear ...
@@ -261,6 +262,14 @@ function unload_mod() {
 		die "failed to unload module $mod (/sys/module)"
 }
 
+# unload_mod(modname) - unload a kernel module
+#	modname - module name to unload
+function unload_mod() {
+	local mod="$1"
+
+	_remove_mod "$mod"
+}
+
 # unload_lp(modname) - unload a kernel module with a livepatch
 #	modname - module name to unload
 function unload_lp() {

-- 
2.54.0


