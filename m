Return-Path: <live-patching+bounces-510-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DCE8095BD50
	for <lists+live-patching@lfdr.de>; Thu, 22 Aug 2024 19:31:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B582287FEC
	for <lists+live-patching@lfdr.de>; Thu, 22 Aug 2024 17:31:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEE061CCB4B;
	Thu, 22 Aug 2024 17:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P42dW2HP"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD1B54918
	for <live-patching@vger.kernel.org>; Thu, 22 Aug 2024 17:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724347894; cv=none; b=LcevojqOTDAIDs75loi2UjI5OM2Zf3+lvc8p+hOtsbSyeaXZ7dzLcFYaaHFQnAJDXdYxq6gvW+rPsgwFOzQISBYii3jA3tDUuw31e2JUYpzct1vGykowDP/+QkXZgZEqHUwjmq1DZ4bg/6adQm50a+RjpqY+XSP84aEFkzuReS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724347894; c=relaxed/simple;
	bh=SjFhoCwvPABXmT0ob4IoesfdJHdQ49/eTWzzaUUsCZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QucGfcnFb6z38EZ/kN5j3vlTTz7i1AVRkxihlU1nZI3p9TO3M+oMERrAkomT1a+MOuHs3/uxV4sIWtU6XMhmgTeybDnIT1+bRDZgYLLh85FX2GHT1tWjwiURu9KLcpPlm5gThNwey2yiEBTMfryXgNPNzAviGq72bQFYymUHgqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P42dW2HP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724347892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CVNpDJyXVCWhuewGfxBVKmPR0aHIcDMgy2nP1xmWxjg=;
	b=P42dW2HPY5b9ZZOjCDZYmLzT34waHPNjpWnqImCmTK/9IORUNoaBD2oqNDR07QDBpJF1k9
	w0rB7Sg4+hvQbnLNDlNdEEHH9ueb6My04EpSoozEtdQ3neTCM3O1hY/Mvz29BzdKEehNdU
	GEaDE3K3Z6PNVMIG2/L6KmNhTjb3EhU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-78-1vfKKIvhNp-BJPmNy9ct0w-1; Thu,
 22 Aug 2024 13:31:29 -0400
X-MC-Unique: 1vfKKIvhNp-BJPmNy9ct0w-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7D0C61955F45;
	Thu, 22 Aug 2024 17:31:27 +0000 (UTC)
Received: from sullivan-work.redhat.com (unknown [10.22.64.64])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3D0FC1955DA7;
	Thu, 22 Aug 2024 17:31:25 +0000 (UTC)
From: Ryan Sullivan <rysulliv@redhat.com>
To: live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	shuah@kernel.org,
	rysulliv@redhat.com
Subject: [PATCH] selftests/livepatch: wait for atomic replace to occur
Date: Thu, 22 Aug 2024 13:31:22 -0400
Message-ID: <20240822173122.14760-1-rysulliv@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On some machines with a large number of CPUs there is a sizable delay
between an atomic replace occurring and when sysfs updates accordingly.
This fix uses 'loop_until' to wait for the atomic replace to unload all
previous livepatches.

Signed-off-by: Ryan Sullivan <rysulliv@redhat.com>
---
 tools/testing/selftests/livepatch/test-livepatch.sh | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/livepatch/test-livepatch.sh b/tools/testing/selftests/livepatch/test-livepatch.sh
index 65c9c058458d..bd13257bfdfe 100755
--- a/tools/testing/selftests/livepatch/test-livepatch.sh
+++ b/tools/testing/selftests/livepatch/test-livepatch.sh
@@ -139,11 +139,8 @@ load_lp $MOD_REPLACE replace=1
 grep 'live patched' /proc/cmdline > /dev/kmsg
 grep 'live patched' /proc/meminfo > /dev/kmsg
 
-mods=(/sys/kernel/livepatch/*)
-nmods=${#mods[@]}
-if [ "$nmods" -ne 1 ]; then
-	die "Expecting only one moduled listed, found $nmods"
-fi
+loop_until 'mods=(/sys/kernel/livepatch/*); nmods=${#mods[@]}; [[ "$nmods" -eq 1 ]]' ||
+        die "Expecting only one moduled listed, found $nmods"
 
 # These modules were disabled by the atomic replace
 for mod in $MOD_LIVEPATCH3 $MOD_LIVEPATCH2 $MOD_LIVEPATCH1; do
-- 
2.44.0


