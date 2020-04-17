Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458F21ADF17
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2020 16:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730863AbgDQOE6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Apr 2020 10:04:58 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23333 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730847AbgDQOE4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Apr 2020 10:04:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587132295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ofPRNPiKndJ+19yFksMsIFZm5zHoy/SE96l7lsxCjLM=;
        b=MskfxfEspysp0br21V3NFFiiLPxaU2hTh30qxCMGLc8u/kKx3EFIN5Hhr2gzg0DSzwvXjj
        x/HxHm3yNu8iqlHMizcUjy8aIgTn6YiJIVrcAGh39l5WaJmLZ5pXez+kYwSXzoLzw5tVMw
        lbAno58dJCYK/5/dsKUrqojmDCdksBA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-XCRqe-RjPOShM75MtGtE1g-1; Fri, 17 Apr 2020 10:04:51 -0400
X-MC-Unique: XCRqe-RjPOShM75MtGtE1g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB6521085942;
        Fri, 17 Apr 2020 14:04:49 +0000 (UTC)
Received: from treble.redhat.com (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8B525C1C5;
        Fri, 17 Apr 2020 14:04:48 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com
Subject: [PATCH v2 5/9] s390: Change s390_kernel_write() return type to match memcpy()
Date:   Fri, 17 Apr 2020 09:04:30 -0500
Message-Id: <8194db48a4aa32caf55fb028669a48ab9ab3c874.1587131959.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1587131959.git.jpoimboe@redhat.com>
References: <cover.1587131959.git.jpoimboe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

