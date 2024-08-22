Return-Path: <live-patching+bounces-508-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65F5295BC0A
	for <lists+live-patching@lfdr.de>; Thu, 22 Aug 2024 18:35:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 957321C2141A
	for <lists+live-patching@lfdr.de>; Thu, 22 Aug 2024 16:35:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 050221CDA01;
	Thu, 22 Aug 2024 16:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bn0/YIth"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D051CCED5
	for <live-patching@vger.kernel.org>; Thu, 22 Aug 2024 16:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724344517; cv=none; b=Tsb9wpYl1kgSfJyMFSltOwWYEr6DkeudH/PnmhHcXgCHD9cOM1VCVjBCloOAbM8Q998Em/6JZ0BwYDFQjJeoc7nhqkKr/FZK1h4WGyiaERSJaRLF7/jMdC6QcEl7OL9WQysC9yYAgiAllkkmbNfzLHqL2dZRLVe6msrY+ZCFjHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724344517; c=relaxed/simple;
	bh=Lebk5qN72eGWhNem5chnt7+jncvqBTsTYp25kGpywi0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qukdxHSVkw+8BI4AEXO8S7qeJC185gyFxaWIeEHZ/WDsnnj22Cx08Ed4Xp08HGfz1pdD+FaJgm4vdI/hRpc+nlbCpl34E/GWJZCEAi++ZXIQeDVmIpHUPTkNiAKbpEiFtJGPF9s+4CvNnjY+Vdj+hLhTXpTeWzqpnp0DRzLiyRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bn0/YIth; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724344515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Mz4WO0VMHsLFOra15E3gL77PpNWfgZXNg9SBsXLcZIk=;
	b=Bn0/YIth90mC2q8aeiV/6WhpUyb7nGm5Wke9r2fkR0yXOZGH/hAmwiPazjoE+DTHIhn9cV
	2VbkBZBbb2gbHpjz2hHfGTIiJN5Uacgh6tXxWGrKg+w6fytAKuRmZ2cXwjnA2ARxkfqzdS
	2ok5r+6ty9Pg1cIdhDtSygcw2/kW/6Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-315-8IlzRdEzPhSlVjwFUYHHuQ-1; Thu,
 22 Aug 2024 12:35:05 -0400
X-MC-Unique: 8IlzRdEzPhSlVjwFUYHHuQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3945B193E8EA;
	Thu, 22 Aug 2024 16:34:46 +0000 (UTC)
Received: from sullivan-work.redhat.com (unknown [10.22.32.213])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C5704300019C;
	Thu, 22 Aug 2024 16:34:43 +0000 (UTC)
From: Ryan Sullivan <rysulliv@redhat.com>
To: live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	shuah@kernel.org
Subject: [PATCH] selftests/livepatch: wait for atomic replace to occur
Date: Thu, 22 Aug 2024 12:34:39 -0400
Message-ID: <20240822163439.13092-1-rysulliv@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Uses 'loop_until' to wait for the atomic replace to unload all previous
livepatches, as on some machines with a large number of CPUs there is a
sizable delay between the atomic replace ocurring and when sysfs
updates accordingly.

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


