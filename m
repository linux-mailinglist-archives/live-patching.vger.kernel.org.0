Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94ED31AC22C
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2020 15:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894973AbgDPNRc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Apr 2020 09:17:32 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31960 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2895032AbgDPNQ7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Apr 2020 09:16:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587043004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=walCYN4WkDNtTgYLVIJ9g+ufVPDd3WAeg5aHW/gs+FQ=;
        b=Zfju2v+hIMLw+T3VeykfqesMm4fjTgmvUpreBL43ZquSNtY5yhRIHSSyl/2awEXblw20tU
        Gnb883zOmELa/SCQxOGuqk+ZEpebFhzbHQqOYO1F8xQG5eFBtgUyaPnNrDuu8Pu/xtV0pn
        EaFIq70Cc265fMlgcRQ40M5MZasUlwo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-AUkX1xh4N-G2HhfxHPoJ2Q-1; Thu, 16 Apr 2020 09:16:40 -0400
X-MC-Unique: AUkX1xh4N-G2HhfxHPoJ2Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72B4980256B;
        Thu, 16 Apr 2020 13:16:38 +0000 (UTC)
Received: from treble (ovpn-116-146.rdu2.redhat.com [10.10.116.146])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7945C10372C0;
        Thu, 16 Apr 2020 13:16:37 +0000 (UTC)
Date:   Thu, 16 Apr 2020 08:16:35 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com
Subject: Re: [PATCH 4/7] s390/module: Use s390_kernel_write() for relocations
Message-ID: <20200416131635.scbpuued6l4xb6qq@treble>
References: <cover.1586881704.git.jpoimboe@redhat.com>
 <e7f2ad87cf83dcdaa7b69b4e37c11fa355bdfe78.1586881704.git.jpoimboe@redhat.com>
 <alpine.LSU.2.21.2004161047410.10475@pobox.suse.cz>
 <20200416120651.wqmoaa35jft4prox@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200416120651.wqmoaa35jft4prox@treble>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Apr 16, 2020 at 07:06:51AM -0500, Josh Poimboeuf wrote:
> On Thu, Apr 16, 2020 at 10:56:02AM +0200, Miroslav Benes wrote:
> > > +	bool early = me->state == MODULE_STATE_UNFORMED;
> > > +
> > > +	return __apply_relocate_add(sechdrs, strtab, symindex, relsec, me,
> > > +				    early ? memcpy : s390_kernel_write);
> > 
> > The compiler warns about
> > 
> > arch/s390/kernel/module.c: In function 'apply_relocate_add':
> > arch/s390/kernel/module.c:453:24: warning: pointer type mismatch in conditional expression
> >          early ? memcpy : s390_kernel_write);
> 
> Thanks, I'll get all that cleaned up.
> 
> I could have sworn I got a SUCCESS message from the kbuild bot.  Does it
> ignore warnings nowadays?

Here's a fix on top of the original patch.

I changed s390_kernel_write() to return "void *" to match memcpy()
(probably a separate patch).

I also grabbed the text_mutex for the !early case in
apply_relocate_add() -- will do something similar for x86.

Will try to test this on a 390 box.


diff --git a/arch/s390/include/asm/uaccess.h b/arch/s390/include/asm/uaccess.h
index a470f1fa9f2a..324438889fe1 100644
--- a/arch/s390/include/asm/uaccess.h
+++ b/arch/s390/include/asm/uaccess.h
@@ -276,6 +276,6 @@ static inline unsigned long __must_check clear_user(void __user *to, unsigned lo
 }
 
 int copy_to_user_real(void __user *dest, void *src, unsigned long count);
-void s390_kernel_write(void *dst, const void *src, size_t size);
+void *s390_kernel_write(void *dst, const void *src, size_t size);
 
 #endif /* __S390_UACCESS_H */
diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index e85e378f876e..2b30ed0ce14f 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -19,6 +19,7 @@
 #include <linux/kasan.h>
 #include <linux/moduleloader.h>
 #include <linux/bug.h>
+#include <linux/memory.h>
 #include <asm/alternative.h>
 #include <asm/nospec-branch.h>
 #include <asm/facility.h>
@@ -175,10 +176,11 @@ int module_frob_arch_sections(Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
 
 static int apply_rela_bits(Elf_Addr loc, Elf_Addr val,
 			   int sign, int bits, int shift,
-			   void (*write)(void *dest, const void *src, size_t len))
+			   void *(*write)(void *dest, const void *src, size_t len))
 {
 	unsigned long umax;
 	long min, max;
+	void *dest = (void *)loc;
 
 	if (val & ((1UL << shift) - 1))
 		return -ENOEXEC;
@@ -196,28 +198,28 @@ static int apply_rela_bits(Elf_Addr loc, Elf_Addr val,
 	}
 
 	if (bits == 8) {
-		write(loc, &val, 1);
+		write(dest, &val, 1);
 	} else if (bits == 12) {
 		unsigned short tmp = (val & 0xfff) |
 			(*(unsigned short *) loc & 0xf000);
-		write(loc, &tmp, 2);
+		write(dest, &tmp, 2);
 	} else if (bits == 16) {
-		write(loc, &val, 2);
+		write(dest, &val, 2);
 	} else if (bits == 20) {
 		unsigned int tmp = (val & 0xfff) << 16 |
 			(val & 0xff000) >> 4 | (*(unsigned int *) loc & 0xf00000ff);
-		write(loc, &tmp, 4);
+		write(dest, &tmp, 4);
 	} else if (bits == 32) {
-		write(loc, &val, 4);
+		write(dest, &val, 4);
 	} else if (bits == 64) {
-		write(loc, &val, 8);
+		write(dest, &val, 8);
 	}
 	return 0;
 }
 
 static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
 		      const char *strtab, struct module *me,
-		      void (*write)(void *dest, const void *src, size_t len))
+		      void *(*write)(void *dest, const void *src, size_t len))
 {
 	struct mod_arch_syminfo *info;
 	Elf_Addr loc, val;
@@ -419,7 +421,7 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
 static int __apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 		       unsigned int symindex, unsigned int relsec,
 		       struct module *me,
-		       void (*write)(void *dest, const void *src, size_t len))
+		       void *(*write)(void *dest, const void *src, size_t len))
 {
 	Elf_Addr base;
 	Elf_Sym *symtab;
@@ -435,7 +437,7 @@ static int __apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 	n = sechdrs[relsec].sh_size / sizeof(Elf_Rela);
 
 	for (i = 0; i < n; i++, rela++) {
-		rc = apply_rela(rela, base, symtab, strtab, me);
+		rc = apply_rela(rela, base, symtab, strtab, me, write);
 		if (rc)
 			return rc;
 	}
@@ -449,8 +451,16 @@ int apply_relocate_add(Elf_Shdr *sechdrs, const char *strtab,
 	int ret;
 	bool early = me->state == MODULE_STATE_UNFORMED;
 
-	return __apply_relocate_add(sechdrs, strtab, symindex, relsec, me,
-				    early ? memcpy : s390_kernel_write);
+	if (!early)
+		mutex_lock(&text_mutex);
+
+	ret = __apply_relocate_add(sechdrs, strtab, symindex, relsec, me,
+				   early ? memcpy : s390_kernel_write);
+
+	if (!early)
+		mutex_unlock(&text_mutex);
+
+	return ret;
 }
 
 int module_finalize(const Elf_Ehdr *hdr,
diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index de7ca4b6718f..22a0be655f27 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -55,19 +55,22 @@ static notrace long s390_kernel_write_odd(void *dst, const void *src, size_t siz
  */
 static DEFINE_SPINLOCK(s390_kernel_write_lock);
 
-void notrace s390_kernel_write(void *dst, const void *src, size_t size)
+notrace void *s390_kernel_write(void *dst, const void *src, size_t size)
 {
+	void *tmp = dst;
 	unsigned long flags;
 	long copied;
 
 	spin_lock_irqsave(&s390_kernel_write_lock, flags);
 	while (size) {
-		copied = s390_kernel_write_odd(dst, src, size);
-		dst += copied;
+		copied = s390_kernel_write_odd(tmp, src, size);
+		tmp += copied;
 		src += copied;
 		size -= copied;
 	}
 	spin_unlock_irqrestore(&s390_kernel_write_lock, flags);
+
+	return dst;
 }
 
 static int __no_sanitize_address __memcpy_real(void *dest, void *src, size_t count)

