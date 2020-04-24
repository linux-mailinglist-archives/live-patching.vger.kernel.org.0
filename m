Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D2C1B6C73
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2020 06:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgDXEMQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 24 Apr 2020 00:12:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22959 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725922AbgDXEMP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 24 Apr 2020 00:12:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587701534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1ORnbYYJvOimK1L52WvsWC1QfTySNsKmDnq5F4Mgpto=;
        b=J9GmZSxO2v1oL/QmWXsnZNX8n3hZBi5Yapd/Y7VlfDCq+bThSnZAGUK0oBtmHyJqILQqMI
        1KUYYzIsPzMYYKcSWvRUwOXQgmSIFjewOmMvpflLReO9JffBL8j7in9VSzOTVf+dvBt0Dt
        zJmPB0Cf9mO5mLiB1MLVzzkjBZMbDHw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-lVzwMglxMhKl9T9PGTuJzQ-1; Fri, 24 Apr 2020 00:12:09 -0400
X-MC-Unique: lVzwMglxMhKl9T9PGTuJzQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4B67835B47;
        Fri, 24 Apr 2020 04:12:07 +0000 (UTC)
Received: from treble (ovpn-118-207.rdu2.redhat.com [10.10.118.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5764D100164D;
        Fri, 24 Apr 2020 04:12:03 +0000 (UTC)
Date:   Thu, 23 Apr 2020 23:12:01 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v2 6/9] s390/module: Use s390_kernel_write() for late
 relocations
Message-ID: <20200424041201.ekbx6wvl3dn45zfl@treble>
References: <18266eb2c2c9a2ce0033426837d89dcb363a85d3.1587131959.git.jpoimboe@redhat.com>
 <20200422164037.7edd21ea@thinkpad>
 <20200422172126.743908f5@thinkpad>
 <20200422194605.n77t2wtx5fomxpyd@treble>
 <20200423141834.234ed0bc@thinkpad>
 <alpine.LSU.2.21.2004231513250.6520@pobox.suse.cz>
 <20200423141228.sjvnxwdqlzoyqdwg@treble>
 <20200423181030.b5mircvgc7zmqacr@treble>
 <20200423232657.7minzcsysnhp474w@treble>
 <20200424023521.GA22117@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200424023521.GA22117@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Apr 23, 2020 at 10:35:21PM -0400, Joe Lawrence wrote:
> > diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
> > index 2798329ebb74..fe446f42818f 100644
> > --- a/arch/s390/kernel/module.c
> > +++ b/arch/s390/kernel/module.c
> > @@ -297,7 +297,7 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr ba=
se, Elf_Sym *symtab,
> > =20
> >  			gotent =3D me->core_layout.base + me->arch.got_offset +
> >  				info->got_offset;
> > -			*gotent =3D val;
> > +			write(gotent, &val, sizeof(*gotent));
> >  			info->got_initialized =3D 1;
> >  		}
> >  		val =3D info->got_offset + rela->r_addend;
> > @@ -330,25 +330,29 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr =
base, Elf_Sym *symtab,
> >  	case R_390_PLTOFF32:	/* 32 bit offset from GOT to PLT. */
> >  	case R_390_PLTOFF64:	/* 16 bit offset from GOT to PLT. */
> >  		if (info->plt_initialized =3D=3D 0) {
> > -			unsigned int *ip;
> > +			unsigned int *ip, insn[5];
> > +
> >  			ip =3D me->core_layout.base + me->arch.plt_offset +
> >  				info->plt_offset;
>=20
> Would it be too paranoid to declare:
>=20
>   			const unsigned int *ip =3D me->core_layout.base +=20
> 						 me->arch.plt_offset +
>   						 info->plt_offset;
>=20
> That would trip an assignment to read-only error if someone were tempte=
d
> to write directly through the pointer in the future.  Ditto for Elf_Add=
r
> *gotent pointer in the R_390_GOTPLTENT case.

The only problem is then the write() triggers a warning because then we
*are* trying to write through the pointer :-)

arch/s390/kernel/module.c:300:10: warning: passing argument 1 of =E2=80=98=
write=E2=80=99 discards =E2=80=98const=E2=80=99 qualifier from pointer ta=
rget type [-Wdiscarded-qualifiers]
  300 |    write(gotent, &val, sizeof(*gotent));

--=20
Josh

