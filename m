Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0BC3E2140
	for <lists+live-patching@lfdr.de>; Wed, 23 Oct 2019 19:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfJWRAk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 23 Oct 2019 13:00:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41470 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726851AbfJWRAj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 23 Oct 2019 13:00:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571850038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mS56Ocf2Wr6s6lxq3UrbaaoGODBCpGlIzwdbwNzrmFM=;
        b=A6f167nnaJ6DttIs4zWbA1olBTys1ifRwlWe0+2BHJqeiNrrz5hF6NX0n/fJzBPJ4cpbrh
        dj6MiydnVp654E3/SS5/MkswuL+TgKl4xzPvc139mDR1g2Urpaor/uj3LsmDwuNycVccHF
        Y8DCdzBiHYtWRH1pA4Eb+ePY5/E41M0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-adgGpz8OP6mPpsyr71ygaA-1; Wed, 23 Oct 2019 13:00:34 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70B2C1800D6B;
        Wed, 23 Oct 2019 17:00:32 +0000 (UTC)
Received: from treble (ovpn-121-225.rdu2.redhat.com [10.10.121.225])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A93D16061E;
        Wed, 23 Oct 2019 17:00:27 +0000 (UTC)
Date:   Wed, 23 Oct 2019 12:00:25 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jeyu@kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v4 15/16] module: Move where we mark modules RO,X
Message-ID: <20191023170025.f34g3vxaqr4f5gqh@treble>
References: <20191018073525.768931536@infradead.org>
 <20191018074634.801435443@infradead.org>
 <20191021135312.jbbxsuipxldocdjk@treble>
 <20191021141402.GI1817@hirez.programming.kicks-ass.net>
 <20191023114835.GT1817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
In-Reply-To: <20191023114835.GT1817@hirez.programming.kicks-ass.net>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: adgGpz8OP6mPpsyr71ygaA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Oct 23, 2019 at 01:48:35PM +0200, Peter Zijlstra wrote:
> Now sadly that commit missed all the useful information, luckily I could
> find the patch in my LKML folder, more sad, that thread still didn't
> contain the actual useful information, for that I was directed to
> github:
>=20
>   https://github.com/dynup/kpatch/issues/580
>=20
> Now, someone is owning me a beer for having to look at github for this.

Deal.  And you probably deserve a few more for fixing our crap.

The github thing is supposed to be temporary, at least in theory we'll
eventually have all klp patch module building code in the kernel tree.

> That finally explained that what happens is that the RELA was trying to
> fix up the paravirt indirect call to 'local_irq_disable', which
> apply_paravirt() will have overwritten with 'CLI; NOP'. This then
> obviously goes *bang*.
>=20
> This then raises a number of questions:
>=20
>  1) why is that RELA (that obviously does not depend on any module)
>     applied so late?

Good question.  The 'pv_ops' symbol is exported by the core kernel, so I
can't see any reason why we'd need to apply that rela late.  In theory,
kpatch-build isn't supposed to convert that to a klp rela.  Maybe
something went wrong in the patch creation code.

I'm also questioning why we even need to apply the parainstructions
section late.  Maybe we can remove that apply_paravirt() call
altogether, along with .klp.arch.parainstruction sections.

I'll need to look into it...

>  2) why can't we unconditionally skip RELA's to paravirt sites?

We could, but I don't think it's needed if we fix #1.

>  3) Is there ever a possible module-dependent RELA to a paravirt /
>     alternative site?

Good question...

> Now, for 1), I would propose '.klp.rela.${mod}' sections only contain
> RELAs that depend on symbols in ${mod} (or modules in general).

That was already the goal, but we've apparently failed at that.

> We can fix up RELAs that depend on core kernel early without problems.
> Let them be in the normal .rela sections and be fixed up on loading
> the patch-module as per usual.

If such symbols aren't exported, then they still need to be in
.klp.rela.vmlinux sections, since normal relas won't work.

> This should also deal with 2, paravirt should always have RELAs into the
> core kernel.
>=20
> Then for 3) we only have alternatives left, and I _think_ it unlikely to
> be the case, but I'll have to have a hard look at that.

I'm not sure about alternatives, but maybe we can enforce such
limitations with tooling and/or kernel checks.

--=20
Josh

