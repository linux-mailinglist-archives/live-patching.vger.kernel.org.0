Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673AE1F5A2B
	for <lists+live-patching@lfdr.de>; Wed, 10 Jun 2020 19:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgFJRVK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 10 Jun 2020 13:21:10 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21739 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727904AbgFJRVJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 10 Jun 2020 13:21:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591809668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8x7zA9DhLqDyItEuwbgv+8oouxrHDSySR8TUcLh+iQM=;
        b=MoVUz+nT4FCI21X0x9xU4WcUCow7mkTk0jhrm4yIONq3YP7uH8chLlhvzWvYEFQXpPXITU
        qA0I0GC16ivR8jaUVLT1LfdRlPw3dYBFtCVJsOiRBjhwFBqdneI4JHIOdmA1L00JCExjnz
        2S/PBFYrrf9sATezLJZQRhvIVP6HC0s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-mwvzNnDFN6qhEhqHIyyxow-1; Wed, 10 Jun 2020 13:21:06 -0400
X-MC-Unique: mwvzNnDFN6qhEhqHIyyxow-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CFA0107ACF4;
        Wed, 10 Jun 2020 17:21:05 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (ovpn-117-142.rdu2.redhat.com [10.10.117.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03C6B1944D;
        Wed, 10 Jun 2020 17:21:04 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH 3/3] selftests/livepatch: filter 'taints' from dmesg comparison
Date:   Wed, 10 Jun 2020 13:21:01 -0400
Message-Id: <20200610172101.21910-4-joe.lawrence@redhat.com>
In-Reply-To: <20200610172101.21910-1-joe.lawrence@redhat.com>
References: <20200610172101.21910-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The livepatch selftests currently filter out "tainting kernel with
TAINT_LIVEPATCH" messages which may be logged when loading livepatch
modules.

Further filter the log to drop "loading out-of-tree module taints
kernel" in the rare case the klp_test modules have been built
out-of-tree.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 tools/testing/selftests/livepatch/functions.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 83560c3df2ee..f5d4ef12f1cb 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -260,7 +260,8 @@ function check_result {
 	local result
 
 	result=$(dmesg --notime | diff --changed-group-format='%>' --unchanged-group-format='' "$SAVED_DMESG" - | \
-		 grep -v 'tainting' | grep -e '^livepatch:' -e 'test_klp')
+		 grep -e '^livepatch:' -e 'test_klp' | \
+		 grep -ve '\<taints\>' -ve '\<tainting\>')
 
 	if [[ "$expect" == "$result" ]] ; then
 		echo "ok"
-- 
2.21.3

