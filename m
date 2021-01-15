Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF832F7CFD
	for <lists+live-patching@lfdr.de>; Fri, 15 Jan 2021 14:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728330AbhAONpr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 15 Jan 2021 08:45:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727357AbhAONpr (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 15 Jan 2021 08:45:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B96BF208E4;
        Fri, 15 Jan 2021 13:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610718306;
        bh=kfWB9xBFVGX686fAnJSkUMhpxtvhmox5jgk5wTkXFU4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EixLYvvPtWx7dvpxs9TOWsY+zTIFxTepO+Sn8pF5HnW7ywVueMyB5gooHeEllmhS1
         5dUL9rX1FAQXaaqXLZl9MVthO6/SSkiYmGxNFxCvdAY7moXE2Fe69UjZJYDpg1X7m9
         6XPGmXM+PBK0MiNn667A4WO95V5ztbXYm53qrm5U9f3WNmwiFHjf73jNKc5KjcUHAk
         G45rVqk2EtwoSPTQBMHt+K/0anPwZmPSkPibCvMfVPO7IKrdZRuAd9b9xxOINcnc/K
         FbFrzY1AfBI/3DgtlyuiUZ8J/vnY2pa0q4LtS5imI5I2fnhkpStOENaCHBRgTNihoj
         M9IoKRotDEvuQ==
Date:   Fri, 15 Jan 2021 13:44:31 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
        linux-arm-kernel@lists.infradead.org,
        Julien Thierry <jthierry@redhat.com>, jpoimboe@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Wendling <morbo@google.com>
Subject: Re: Live patching on ARM64
Message-ID: <20210115134431.GC4384@sirena.org.uk>
References: <f3fe6a60-9ac2-591d-1b83-9113c50dc492@linux.microsoft.com>
 <20210115123347.GB39776@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ZwgA9U+XZDXt4+m+"
Content-Disposition: inline
In-Reply-To: <20210115123347.GB39776@C02TD0UTHF1T.local>
X-Cookie: Debug is human, de-fix divine.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 15, 2021 at 12:33:47PM +0000, Mark Rutland wrote:
> On Thu, Jan 14, 2021 at 04:07:55PM -0600, Madhavan T. Venkataraman wrote:
> > Hi all,
> >=20
> > My name is Madhavan Venkataraman.
>=20
> Hi Madhavan,
>=20
> > Microsoft is very interested in Live Patching support for ARM64.
> > On behalf of Microsoft, I would like to contribute.
> >=20
> > I would like to get in touch with the people who are currently working
> > in this area, find out what exactly they are working on and see if they
> > could use an extra pair of eyes/hands with what they are working on.
> >=20
> > It looks like the most recent work in this area has been from the
> > following folks:

Also copying in Bill Wendling who has also expressed an interest in
this.  Not deleting context for his benefit.

> > Mark Brown and Mark Rutland:
> > 	Kernel changes to providing reliable stack traces.
> >=20
> > Julien Thierry:
> > 	Providing ARM64 support in objtool.
> >=20
> > Torsten Duwe:
> > 	Ftrace with regs.
>=20
> IIRC that's about right. I'm also trying to make arm64 patch-safe (more
> on that below), and there's a long tail of work there for anyone
> interested.
>=20
> > I apologize if I have missed anyone else who is working on Live Patching
> > for ARM64. Do let me know.
> >=20
> > Is there any work I can help with? Any areas that need investigation, a=
ny code
> > that needs to be written, any work that needs to be reviewed, any testi=
ng that
> > needs to done? You folks are probably super busy and would not mind an =
extra
> > hand.
>=20
> One general thing that I believe we'll need to do is to rework code to
> be patch-safe (which implies being noinstr-safe too). For example, we'll
> need to rework the instruction patching code such that this cannot end
> up patching itself (or anything that has instrumented it) in an unsafe
> way.
>=20
> Once we have objtool it should be possible to identify those cases
> automatically. Currently I'm aware that we'll need to do something in at
> least the following places:
>=20
> * The entry code -- I'm currently chipping away at this.
>=20
> * The insn framework (which is used by some patching code), since the
>   bulk of it lives in arch/arm64/kernel/insn.c and isn't marked noinstr.
>  =20
>   We can probably shift the bulk of the aarch64_insn_gen_*() and
>   aarch64_get_*() helpers into a header as __always_inline functions,
>   which would allow them to be used in noinstr code. As those are
>   typically invoked with a number of constant arguments that the
>   compiler can fold, this /might/ work out as an optimization if the
>   compiler can elide the error paths.
>=20
> * The alternatives code, since we call instrumentable and patchable
>   functions between updating instructions and performing all the
>   necessary maintenance. There are a number of cases within
>   __apply_alternatives(), e.g.
>=20
>   - test_bit()
>   - cpus_have_cap()
>   - pr_info_once()
>   - lm_alias()
>   - alt_cb, if the callback is not marked as noinstr, or if it calls
>     instrumentable code (e.g. from the insn framework).
>   - clean_dcache_range_nopatch(), as read_sanitised_ftr_reg() and
>     related code can be instrumented.
>=20
>   This might need some underlying rework elsewhere (e.g. in the
>   cpufeature code, or atomics framework).
>=20
> So on the kernel side, maybe a first step would be to try to headerize
> the insn generation code as __always_inline, and see whether that looks
> ok? With that out of the way it'd be a bit easier to rework patching
> code depending on the insn framework.
>=20
> I'm not sure about the objtool side, so I'll leave that to Julien and co
> to answer.
>=20
> Thanks,
> Mark.

--ZwgA9U+XZDXt4+m+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmABnD4ACgkQJNaLcl1U
h9AmDAf/QKy9ebi1OoNZfIxeqCcuZiKmlCUgvSvISDUA8o8h6CF10gJs5WjY8qAb
M3iYHq2isyCyDdt9N+aKNOmHjPDqshYcmMVd7C4BSZCzdz1htoPe6NSGC/x7bis4
sNclBOS9aeFy2ej8pBZJiL7mJ0/c1XJxnzKppPYLz2sUMDNqGqVl1vcRtx05dU1V
0/mQnPoCzlkWs1MpgzL67DN8USS00po4iYgPQ9fUrXT+M62PBWd8yE+6jBFPwmEm
pO7ijJroy0rbuL4ARXOwPp4mAaCU7yLqc2wnEyJaoXX+iELZRFkcImrH8J8nIwm6
2MqCY5RZkJtbVfaQfbfTTyFuhib9LQ==
=iKDL
-----END PGP SIGNATURE-----

--ZwgA9U+XZDXt4+m+--
