Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 873EEF21B3
	for <lists+live-patching@lfdr.de>; Wed,  6 Nov 2019 23:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbfKFW2J (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 6 Nov 2019 17:28:09 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29973 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726817AbfKFW2J (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 6 Nov 2019 17:28:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573079288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=OaCfCwRffXSl+3ViahqGn4EpovGGgu/EbhfMP+EYy0E=;
        b=QNYlmft6IH7dSieGq1LegFVgJq7l6a5RxxfipY8fuV5hE5csYOxaPSdh9+edJ5OVUYBvDI
        EPNJUWIbM9sqnja1CVWehTBFobEo8egSatktQi8ApmTmzpwxe+thDPtd5jDtZDKaM+gcmm
        RB91sdYKjsnIfZFMOYk/dx10daRlU5A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-ACruvKVuPtyL9jLRdIE6Ow-1; Wed, 06 Nov 2019 17:28:05 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C09E800C73;
        Wed,  6 Nov 2019 22:28:04 +0000 (UTC)
Received: from jlaw-desktop.bos.redhat.com (dhcp-17-119.bos.redhat.com [10.18.17.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3FAA19757;
        Wed,  6 Nov 2019 22:28:03 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     shuah@kernel.org
Subject: [PATCH] selftests/livepatch: filter 'taints' from dmesg comparison
Date:   Wed,  6 Nov 2019 17:28:01 -0500
Message-Id: <20191106222801.7541-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: ACruvKVuPtyL9jLRdIE6Ow-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The livepatch selftests compare expected dmesg output to verify kernel
behavior.  They currently filter out "tainting kernel with
TAINT_LIVEPATCH" messages which may be logged when loading livepatch
modules.

Further filter the log to also drop "loading out-of-tree module taints
kernel" messages in case the klp_test modules have been build without
the in-tree module flag.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---

Note: I stumbled across this in a testing scenario and thought it might
be generally useful to extend this admittedly fragile mechanism.  Since
there are no related livepatch-core changes, this can go through Shuah's
kselftest tree if she prefers.  -- Joe

 tools/testing/selftests/livepatch/functions.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing=
/selftests/livepatch/functions.sh
index 79b0affd21fb..57975c323542 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -221,7 +221,7 @@ function check_result {
 =09local expect=3D"$*"
 =09local result
=20
-=09result=3D$(dmesg | grep -v 'tainting' | grep -e 'livepatch:' -e 'test_k=
lp' | sed 's/^\[[ 0-9.]*\] //')
+=09result=3D$(dmesg | grep -ve '\<taints\>' -ve '\<tainting\>' | grep -e '=
livepatch:' -e 'test_klp' | sed 's/^\[[ 0-9.]*\] //')
=20
 =09if [[ "$expect" =3D=3D "$result" ]] ; then
 =09=09echo "ok"
--=20
2.21.0

