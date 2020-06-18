Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0174C1FFAD3
	for <lists+live-patching@lfdr.de>; Thu, 18 Jun 2020 20:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729997AbgFRSLH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 18 Jun 2020 14:11:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28616 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730006AbgFRSLC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 18 Jun 2020 14:11:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592503859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZZWlQ5y7Pb1QamFT51VCVsggHmDjllVGDgfPdvXE2UE=;
        b=Btd3kdnARj/TaKqOXuaH9GE9kZ55nCU8kODKxtYdtujhTykAVM7GGF0KQwbj7lIq1VT9/Y
        +h3uIo9V5GOLawQPXeiuDJ7uc1Qfoqc2wtnQAyPUGxT8JzAiDLWs8buBkZSC2CEvwnHHlV
        EUvJao3WYRPQWDBzZsN7Lm3D0GYyDL8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-GJu4NKrCMYixIcj9daZjdQ-1; Thu, 18 Jun 2020 14:10:55 -0400
X-MC-Unique: GJu4NKrCMYixIcj9daZjdQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E104835B5D;
        Thu, 18 Jun 2020 18:10:54 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (ovpn-112-56.rdu2.redhat.com [10.10.112.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0E1E1E2261;
        Thu, 18 Jun 2020 18:10:53 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, Yannick Cote <ycote@redhat.com>
Subject: [PATCH v3 3/3] selftests/livepatch: add test delimiter to dmesg
Date:   Thu, 18 Jun 2020 14:10:40 -0400
Message-Id: <20200618181040.21132-4-joe.lawrence@redhat.com>
In-Reply-To: <20200618181040.21132-1-joe.lawrence@redhat.com>
References: <20200618181040.21132-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Make it bit easier to parse the kernel logs during the selftests by
adding a "===== TEST: $test =====" delimiter when each individual test
begins.

Suggested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Revieved-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Yannick Cote <ycote@redhat.com>
---
 tools/testing/selftests/livepatch/functions.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 5e5a79179fc1..36648ca367c2 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -264,6 +264,7 @@ function start_test {
 
 	save_dmesg
 	echo -n "TEST: $test ... "
+	log "===== TEST: $test ====="
 }
 
 # check_result() - verify dmesg output
-- 
2.21.3

