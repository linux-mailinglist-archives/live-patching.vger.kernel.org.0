Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163D41BE29E
	for <lists+live-patching@lfdr.de>; Wed, 29 Apr 2020 17:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgD2PZP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Apr 2020 11:25:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25059 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726476AbgD2PZP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Apr 2020 11:25:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588173914;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sPXjVtqc214o8ubA6ZREyK/4uh96PCzZ+mk9a6forIA=;
        b=UnM46rUjemPVHvADjzT3tqZ/fUR95+ITkIKIv6FrUicCNm5bSrrV+Ja2lX8q6znxnAhilj
        GHmSORQsRs1pjBZ0jOSUROFDRu8ZrHb816Ojs3OypvVhExmdHDDGgzw6aHCiaeXZmDf4P8
        RUyuHYHWgyCLTSm0HI1IQpsO+n/ZU+s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-256-0MB_1HNoOVyS8kdGLYXxeg-1; Wed, 29 Apr 2020 11:25:10 -0400
X-MC-Unique: 0MB_1HNoOVyS8kdGLYXxeg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC8C01009628;
        Wed, 29 Apr 2020 15:25:06 +0000 (UTC)
Received: from treble.redhat.com (ovpn-113-19.rdu2.redhat.com [10.10.113.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABB1C605CB;
        Wed, 29 Apr 2020 15:25:05 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com
Subject: [PATCH v4 05/11] s390: Change s390_kernel_write() return type to match memcpy()
Date:   Wed, 29 Apr 2020 10:24:47 -0500
Message-Id: <be5119b30920d2da6fca3f6d2b1aca5712a2fd30.1588173720.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1588173720.git.jpoimboe@redhat.com>
References: <cover.1588173720.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

s390_kernel_write()'s function type is almost identical to memcpy().
Change its return type to "void *" so they can be used interchangeably.

Cc: linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
Acked-by: Miroslav Benes <mbenes@suse.cz>
---
 arch/s390/include/asm/uaccess.h | 2 +-
 arch/s390/mm/maccess.c          | 9 ++++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uacc=
ess.h
index a470f1fa9f2a..324438889fe1 100644
--- a/arch/s390/include/asm/uaccess.h
+++ b/arch/s390/include/asm/uaccess.h
@@ -276,6 +276,6 @@ static inline unsigned long __must_check clear_user(v=
oid __user *to, unsigned lo
 }
=20
 int copy_to_user_real(void __user *dest, void *src, unsigned long count)=
;
-void s390_kernel_write(void *dst, const void *src, size_t size);
+void *s390_kernel_write(void *dst, const void *src, size_t size);
=20
 #endif /* __S390_UACCESS_H */
diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index de7ca4b6718f..22a0be655f27 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -55,19 +55,22 @@ static notrace long s390_kernel_write_odd(void *dst, =
const void *src, size_t siz
  */
 static DEFINE_SPINLOCK(s390_kernel_write_lock);
=20
-void notrace s390_kernel_write(void *dst, const void *src, size_t size)
+notrace void *s390_kernel_write(void *dst, const void *src, size_t size)
 {
+	void *tmp =3D dst;
 	unsigned long flags;
 	long copied;
=20
 	spin_lock_irqsave(&s390_kernel_write_lock, flags);
 	while (size) {
-		copied =3D s390_kernel_write_odd(dst, src, size);
-		dst +=3D copied;
+		copied =3D s390_kernel_write_odd(tmp, src, size);
+		tmp +=3D copied;
 		src +=3D copied;
 		size -=3D copied;
 	}
 	spin_unlock_irqrestore(&s390_kernel_write_lock, flags);
+
+	return dst;
 }
=20
 static int __no_sanitize_address __memcpy_real(void *dest, void *src, si=
ze_t count)
--=20
2.21.1

