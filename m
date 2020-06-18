Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939B41FFAD1
	for <lists+live-patching@lfdr.de>; Thu, 18 Jun 2020 20:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbgFRSLB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 18 Jun 2020 14:11:01 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58728 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726882AbgFRSK6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 18 Jun 2020 14:10:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592503857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LHGyp6CYIKGOqwxes/zzCO/ZvJIZQruxra7ZLeYTBQU=;
        b=C5MVAwQAd8J0LlByERRCq5NcToZySX6AAMznEIMJ8Px8ZsCgsQ6xvtwJGcnY6OrvaSvGou
        a8GsToF6yO2OOPW0pSXkyIjsIQ8NBqmrHuLa3Evs26i9t++RNjDHiZ81PawMD1WxC8zCKc
        5ArGKDAGJQ9CLGYhLYo4om4p62Ixv+E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-u01PmpGkOlmYIPKnLHNA5A-1; Thu, 18 Jun 2020 14:10:53 -0400
X-MC-Unique: u01PmpGkOlmYIPKnLHNA5A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04348107BEF5;
        Thu, 18 Jun 2020 18:10:52 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (ovpn-112-56.rdu2.redhat.com [10.10.112.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BE701E2261;
        Thu, 18 Jun 2020 18:10:51 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, Yannick Cote <ycote@redhat.com>
Subject: [PATCH v3 0/3] selftests/livepatch: small script cleanups
Date:   Thu, 18 Jun 2020 14:10:37 -0400
Message-Id: <20200618181040.21132-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Petr,

Given the realization about kernel log timestamps and partial log
comparison with v2, I respun a final version dropping the dmesg --notime
patch, fixed any rebase conflicts, and added a comment per your
suggestion.

I copied all the ack and review tags from v2 since the patchset is
unchanged otherwise.  Hopefully this v3 minimizes any maintainer
fiddling on your end.

I did iterate through the patches and verified that I could run each
multiple times without the dmesg comparison getting confused.

Thanks,

-- Joe


v3:

- when modifying the dmesg comparision to select only new messages in
  patch 1, add a comment explaining the importance of timestamps to
  accurately pick from where the log left off at start_test [pmladek]

- since Petr determined that the timestamps were in fact very important
  to maintain for the dmesg / diff comparision, drop the patch which
  added --notime to dmesg invocations [pmladek]

- update the comparision regex filter for 'livepatch:' now that it's
  going to be prefixed by '[timestamp] ' and no longer at the start of
  the buffer line.  This part of the log comparison should now be
  unmodified by the patchset.

Joe Lawrence (3):
  selftests/livepatch: Don't clear dmesg when running tests
  selftests/livepatch: refine dmesg 'taints' in dmesg comparison
  selftests/livepatch: add test delimiter to dmesg

 tools/testing/selftests/livepatch/README      | 16 +++---
 .../testing/selftests/livepatch/functions.sh  | 37 ++++++++++++-
 .../selftests/livepatch/test-callbacks.sh     | 55 ++++---------------
 .../selftests/livepatch/test-ftrace.sh        |  4 +-
 .../selftests/livepatch/test-livepatch.sh     | 12 +---
 .../selftests/livepatch/test-shadow-vars.sh   |  4 +-
 .../testing/selftests/livepatch/test-state.sh | 21 +++----
 7 files changed, 68 insertions(+), 81 deletions(-)

-- 
2.21.3

