Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D628340CE8
	for <lists+live-patching@lfdr.de>; Thu, 18 Mar 2021 19:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhCRS03 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 18 Mar 2021 14:26:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232260AbhCRS0M (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 18 Mar 2021 14:26:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E01F364F1F;
        Thu, 18 Mar 2021 18:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616091971;
        bh=LA+r6D7m6AvZU8wuhj/IzzDyDVbkFpktbFnAV3fhL28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AzB/AcnyIbEKFHztNHVvwDayVAqwTDd2mSG/o6sbtKIyBZHKlff8PIf5SIWr2iKw5
         mIhJ4+JMTZXoUTvBot/OXKopUL2AvoxNkdOjKM1iTs90ghNW+Vm2f5NdXZh3qv/w+L
         xXR2hLGjovCMgLODZbytYaIdXUE4iqXfLsqM/HBfHs3+SIuadV1ZMsTnjdWUsz0Bzj
         VoK73kMvzFF1dyK0VJnPxulq539B0aJoLOHIuauc/xYi2LDIrOJcdkf4cwCQE7wjfN
         hLZBRmTqbXtQED9JX5m79Bs2reMnTIo9thxv9rtx8zWFAsvezlZD4QabM0wca4Oq5Z
         uow2Ffn7qEeHQ==
Date:   Thu, 18 Mar 2021 18:26:07 +0000
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/8] arm64: Terminate the stack trace at
 TASK_FRAME and EL0_FRAME
Message-ID: <20210318182607.GO5469@sirena.org.uk>
References: <5997dfe8d261a3a543667b83c902883c1e4bd270>
 <20210315165800.5948-1-madvenka@linux.microsoft.com>
 <20210315165800.5948-4-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="z87VqPJ/HsYrR2WM"
Content-Disposition: inline
In-Reply-To: <20210315165800.5948-4-madvenka@linux.microsoft.com>
X-Cookie: You are false data.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--z87VqPJ/HsYrR2WM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 15, 2021 at 11:57:55AM -0500, madvenka@linux.microsoft.com wrot=
e:

> +	/* Terminal record, nothing to unwind */
> +	if (fp =3D=3D (unsigned long) regs->stackframe) {
> +		if (regs->frame_type =3D=3D TASK_FRAME ||
> +		    regs->frame_type =3D=3D EL0_FRAME)
> +			return -ENOENT;
>  		return -EINVAL;
> +	}

This is conflating the reliable stacktrace checks (which your series
will later flag up with frame->reliable) with verifying that we found
the bottom of the stack by looking for this terminal stack frame record.
For the purposes of determining if the unwinder got to the bottom of the
stack we don't care what stack type we're looking at, we just care if it
managed to walk to this defined final record. =20

At the minute nothing except reliable stack trace has any intention of
checking the specific return code but it's clearer to be consistent.

--z87VqPJ/HsYrR2WM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmBTmz8ACgkQJNaLcl1U
h9Cf4wf9GiUVSakCRf5uwTSCNkO20M1jY8gGOIf0HAWMgakyvTKAsskA/ejAOckA
rAFeoOQAiW+U82Xxi3cvoM7Q9/nPp4D0nUEbSVN+LEoNM1BD3PXuYwrv8BLr2mh8
Ow3HG0jZ87pBCvQa0tKD+l7sGJEDplfsx/GeM/diTBn8YTquajA5HQdDlJEJeWzz
vhJiQlkNLmsJVAk3rJ+IuzteoOb6L7CfkdVT+aBtfa1TLqRK3XmLJU5GLe+nbHBP
0/MdK5UMb7jvvZnfn3jDyFpYzhk8RgUu9VYrLYHeDAr1OdpYdY/KB/zrcSb58brt
3jGrgdNQgiIMaAToV9BX4H/4nslg3A==
=jp9g
-----END PGP SIGNATURE-----

--z87VqPJ/HsYrR2WM--
