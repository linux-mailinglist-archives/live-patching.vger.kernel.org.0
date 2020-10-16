Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699B92904D0
	for <lists+live-patching@lfdr.de>; Fri, 16 Oct 2020 14:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404129AbgJPMPo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Oct 2020 08:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394797AbgJPMPo (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Oct 2020 08:15:44 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AD8020866;
        Fri, 16 Oct 2020 12:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602850543;
        bh=24Lc1b+Pi+M/t0WcbPQha6zss1kGe1/xX34XmWdX4tQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NElYO+lmQEsrrbxfviMswNS1RBfGWGMUwE++MxKsMIsU5EztZNTvQL8DLR5bpK0FP
         GDdEoY/uvS5yeRUClMemPCfcZE7isKoNfOo72QLk7Q9cxIw1gAgvsKey0gdvA0LYJq
         JsmKPyhHxc8RkiS64UEpef3/FVWh5eOCAs13Z3Bo=
Date:   Fri, 16 Oct 2020 13:15:34 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] arm64: Implement reliable stack trace
Message-ID: <20201016121534.GC5274@sirena.org.uk>
References: <20201012172605.10715-1-broonie@kernel.org>
 <alpine.LSU.2.21.2010151533490.14094@pobox.suse.cz>
 <20201015141612.GC50416@C02TD0UTHF1T.local>
 <20201015154951.GD4390@sirena.org.uk>
 <20201015212931.mh4a5jt7pxqlzxsg@treble>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nmemrqcdn5VTmUEE"
Content-Disposition: inline
In-Reply-To: <20201015212931.mh4a5jt7pxqlzxsg@treble>
X-Cookie: Pournelle must die!
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--nmemrqcdn5VTmUEE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2020 at 04:29:31PM -0500, Josh Poimboeuf wrote:
> I can't see the original patch.  Can the original poster (Mark B?) add
> me to Cc on the next version?

https://lore.kernel.org/linux-arm-kernel/20201012172605.10715-1-broonie@ker=
nel.org/

> It's also good practice to add lkml as well.  That way, those of us not
> copied can at least find the patch in the archives.

> live-patching@vger.kernel.org would also be a good idea for this one.

Sorry about that.  I don't know if it's worth including a K: pattern for
arch_stack_walk_reliable() in the livepatch entry in MAINTAINERS?

> If by cargo culting, you mean reverse engineering the requirements due
> to lack of documentation, that's fair.

Yes, exactly - just copying the existing implementations and hoping that
it's sensible/relevant and covers everything that's needed.  It's not
entirely clear what a reliable stacktrace is expected to do that a
normal stacktrace doesn't do beyond returning an error code.

> > The searching for a defined thread entry point for example isn't
> > entirely visible in the implementations.

> For now I'll speak only of x86, because I don't quite remember how
> powerpc does it.

> For thread entry points, aka the "end" of the stack:

> - For ORC, the end of the stack is either pt_regs, or -- when unwinding
>   from kthreads, idle tasks, or irqs/exceptions in entry code --
>   UNWIND_HINT_EMPTY (found by the unwinder's check for orc->end.

>   [ Admittedly the implementation needs to be cleaned up a bit.  EMPTY
>     is too broad and needs to be split into UNDEFINED and ENTRY. ]

> - For frame pointers, by convention, the end of the stack for all tasks
>   is a defined stack offset: end of stack page - sizeof(pt_regs).

> And yes, all that needs to be documented.

Ah, I'd have interpreted "defined thread entry point" as meaning
expecting to find specific functions appering at the end of the stack
rather than meaning positively identifying the end of the stack - for
arm64 we use a NULL frame pointer to indicate this in all situations.
In that case that's one bit that is already clear.

=46rom the list Miroslav posted the bits I wouldn't have inferred were:

 - Detecting preemption/page faults
 - Preventing recursive loops
 - Verifying that return addresses are text addresses

--nmemrqcdn5VTmUEE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl+JjuUACgkQJNaLcl1U
h9BS2wf/Z6CLxRR0hhBEAjvRI6fLS0+gilqKn3l6WApnUWrRmunhSQKo9tW8JLUp
AzlgXljcMebmSzqocCEHBWXHUctmhCCB19corEaF14qiMaUHrv6QLh3+e44PtUS1
YJQbb5kB2YzVEeUYjKMJnEfeyC4dWF+7maxuh0FPfnUIvTwf++MC4NOGMccWEybE
uK0xfLiaq6hevnEQv5rhFHthEGwxu7hMUtKP+jNmF0ipTXpijYsrSZdpyXS5O3xL
mricOZvRKms3gT1ZZQGfcsOVp4jWi97TqLT7LAmi7DH/7VbvlQtbTtkj+h0q2PVQ
+bI0uXct4T1mWCJqzvKXAuqB1etgdw==
=LjKW
-----END PGP SIGNATURE-----

--nmemrqcdn5VTmUEE--
