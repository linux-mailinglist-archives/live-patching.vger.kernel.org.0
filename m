Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73C446E2D7
	for <lists+live-patching@lfdr.de>; Thu,  9 Dec 2021 08:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhLIHEG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 Dec 2021 02:04:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbhLIHEG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 Dec 2021 02:04:06 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21548C061746
        for <live-patching@vger.kernel.org>; Wed,  8 Dec 2021 23:00:33 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J8lKq34mPz4xZ1;
        Thu,  9 Dec 2021 18:00:30 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1639033231;
        bh=0SaTLCj7ZgJC+r5tGcYKix4eghqio7Gn7G/1ppPlsn4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=li+/UqSpLZKYxNjpwk8eBHvvDl48VaKX5idcKjBhXvDfouSo1ttzIPZFVlxCquWLY
         ppSHJQHD52UAjpPTraIQ7Cnw6OX3FcMKxxr8lf3mDRmukHtbXiU5AS9+BMxoWlwtdE
         vF/HPV73+f2fLcGpIwHpWeRw3OvPfOX4OdzJ0txVBDCewRBWp9D5rxoRcrlB7JI/9q
         xYFresrDfZSNfz6FxfaZfnKKz1OnRB8PWleVs34eDYRR0jd/x4PhMHe+nxffBxyLHj
         woyuGgHi+sOIRQcGnCITDdqWzDprbWC/CkQyTay7P508pcF7tzVmyqNKp/xrvZAehu
         l6m0+7ec3CTfg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Russell Currey <ruscur@russell.cc>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     jniethe5@gmail.com, naveen.n.rao@linux.vnet.ibm.com,
        christophe.leroy@csgroup.eu, live-patching@vger.kernel.org
Subject: Re: [PATCH] powerpc/module_64: Fix livepatching for RO modules
In-Reply-To: <25d35b916e87ed7a71ebc6528259e2f0ed390cb2.camel@russell.cc>
References: <20211123081520.18843-1-ruscur@russell.cc>
 <d9d9ef2d-4aaa-7d8b-d15e-0452a355c5cf@redhat.com>
 <25d35b916e87ed7a71ebc6528259e2f0ed390cb2.camel@russell.cc>
Date:   Thu, 09 Dec 2021 18:00:30 +1100
Message-ID: <87y24umfe9.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Russell Currey <ruscur@russell.cc> writes:
> On Tue, 2021-12-07 at 09:44 -0500, Joe Lawrence wrote:
>> On 11/23/21 3:15 AM, Russell Currey wrote:
>>=20
>> [[ cc +=3D livepatching list ]]
>>=20
>> Hi Russell,
>>=20
>> Thanks for writing a minimal fix for stable / backporting.=C2=A0 As I
>> mentioned on the github issue [1], this avoided the crashes I
>> reported
>> here and over on kpatch github [2].=C2=A0 I wasn't sure if this is the
>> final
>> version for stable, but feel free to add my:
>>=20
>> Tested-by: Joe Lawrence <joe.lawrence@redhat.com>
>
> Thanks Joe, as per the discussions on GitHub I think we're fine to use
> this patch for a fix for stable (unless there's new issues found or
> additional community feedback etc).

Hmm, I read the GitHub discussion as being that you were going to do
another version, which is why I haven't picked this up. But I guess you
and Christophe were talking about the non-minimal fix.

I know we want this to be minimal, but I think it should be checking
that patch_instruction() isn't failing.

Incremental diff to do that is below. It boots OK, are you able to throw
a livepatch test at it?

cheers



diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_6=
4.c
index c25ef36c3ef4..5d77d3f5fbb5 100644
--- a/arch/powerpc/kernel/module_64.c
+++ b/arch/powerpc/kernel/module_64.c
@@ -429,8 +429,9 @@ static inline int create_stub(const Elf64_Shdr *sechdrs,
 		return create_ftrace_stub(entry, addr, me);
=20
 	for (i =3D 0; i < sizeof(ppc64_stub_insns) / sizeof(u32); i++) {
-		patch_instruction(&entry->jump[i],
-				  ppc_inst(ppc64_stub_insns[i]));
+		if (patch_instruction(&entry->jump[i],
+				      ppc_inst(ppc64_stub_insns[i])))
+			return 0;
 	}
=20
 	/* Stub uses address relative to r2. */
@@ -442,19 +443,24 @@ static inline int create_stub(const Elf64_Shdr *sechd=
rs,
 	}
 	pr_debug("Stub %p get data from reladdr %li\n", entry, reladdr);
=20
-	patch_instruction(&entry->jump[0],
-			  ppc_inst(entry->jump[0] | PPC_HA(reladdr)));
-	patch_instruction(&entry->jump[1],
-			  ppc_inst(entry->jump[1] | PPC_LO(reladdr)));
+	if (patch_instruction(&entry->jump[0],
+			      ppc_inst(entry->jump[0] | PPC_HA(reladdr))))
+		return 0;
+
+	if (patch_instruction(&entry->jump[1],
+			  ppc_inst(entry->jump[1] | PPC_LO(reladdr))))
+		return 0;
=20
 	// func_desc_t is 8 bytes if ABIv2, else 16 bytes
 	desc =3D func_desc(addr);
 	for (i =3D 0; i < sizeof(func_desc_t) / sizeof(u32); i++) {
-		patch_instruction(((u32 *)&entry->funcdata) + i,
-				  ppc_inst(((u32 *)(&desc))[i]));
+		if (patch_instruction(((u32 *)&entry->funcdata) + i,
+				      ppc_inst(((u32 *)(&desc))[i])))
+			return 0;
 	}
=20
-	patch_instruction(&entry->magic, ppc_inst(STUB_MAGIC));
+	if (patch_instruction(&entry->magic, ppc_inst(STUB_MAGIC)))
+		return 0;
=20
 	return 1;
 }
@@ -509,8 +515,11 @@ static int restore_r2(const char *name, u32 *instructi=
on, struct module *me)
 			me->name, *instruction, instruction);
 		return 0;
 	}
+
 	/* ld r2,R2_STACK_OFFSET(r1) */
-	patch_instruction(instruction, ppc_inst(PPC_INST_LD_TOC));
+	if (patch_instruction(instruction, ppc_inst(PPC_INST_LD_TOC)))
+		return 0;
+
 	return 1;
 }
=20
@@ -652,7 +661,10 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 			/* Only replace bits 2 through 26 */
 			value =3D (*(uint32_t *)location & ~0x03fffffc)
 				| (value & 0x03fffffc);
-			patch_instruction((u32 *)location, ppc_inst(value));
+
+			if (patch_instruction((u32 *)location, ppc_inst(value)))
+				return -EFAULT;
+
 			break;
=20
 		case R_PPC64_REL64:
