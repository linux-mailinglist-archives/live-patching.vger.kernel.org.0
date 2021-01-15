Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE9A2F81E7
	for <lists+live-patching@lfdr.de>; Fri, 15 Jan 2021 18:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730719AbhAOROH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 15 Jan 2021 12:14:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:50302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728560AbhAOROG (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 15 Jan 2021 12:14:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0E14238EE;
        Fri, 15 Jan 2021 17:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610730806;
        bh=QA+NQgahMmlU3MoByVcdSlaI7t9LlLaIO4mdz8ajoko=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=maz5JIZQyG67rBDzaSWHoJaCOdFj0s+hbR+VOS3OiwzhPrv04ylz6eQ1XWnJOfZT3
         rsM2PUsuFyXT+UYZS9tdRaIkJnd3PIdIcLk5Zt5HVSvDKfD770pZNZVWZwOFYQ926h
         Dq5rs9fG/qYBq5bblhtT8N/SYpewJHgshsYIbfTJmS6CuelHZoUzB13PbqXJpAzR3o
         KjHzZcbf/+7PaTMr+CNiKRbQ7qWmt9TdxZvHMArid2Fi/1wjPN/JH5He4v2+C3bOb4
         ZKK+jTI4HnyfPcRLUWLTq1yarcbh0KfazaKNyAo6LNIcmoIChtduVtmjrxs2HHT4QO
         n9t5EeVhfndRg==
Date:   Fri, 15 Jan 2021 17:12:51 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org, linux-doc@vgert.kernel.org
Subject: Re: [PATCH v3] Documentation: livepatch: document reliable stacktrace
Message-ID: <20210115171251.GF4384@sirena.org.uk>
References: <20210115142446.13880-1-broonie@kernel.org>
 <20210115164718.GE44111@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="L2Brqb15TUChFOBK"
Content-Disposition: inline
In-Reply-To: <20210115164718.GE44111@C02TD0UTHF1T.local>
X-Cookie: Debug is human, de-fix divine.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--L2Brqb15TUChFOBK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 15, 2021 at 04:47:18PM +0000, Mark Rutland wrote:
> On Fri, Jan 15, 2021 at 02:24:46PM +0000, Mark Brown wrote:

> > +    3. Considerations
> > +       3.1 Identifying successful termination

> It looks like we forgot to update this with the addition of the new
> section 3, so this needs a trivial update to add that and fix the
> numbering.

Bah, I thought the point with structured documentation formats was that
tooling would handle stuff like this :/

> Otherwise this looks good; thanks for taking this off my hands! :)

Thanks for doing almost all the work!

--L2Brqb15TUChFOBK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmABzRIACgkQJNaLcl1U
h9D1hQf9FqAZaCxL347E0LGXgKPI3UHA3dt8uHFPwiaVQdat3BC+MgTfodRK+eq+
5/rHtninQOmPhorco8azT6iHVw2FiNpEpnA50zLOtyVlCoG/I0NPjK7oBWx404xs
GbBUMC7oBY2IZepl9M4DZem1szPxNCL68ankhNj0i21viVs80+HxS7TqZTrgk0Qz
YSfalzJ3d1S3WIsAaFkWzTn10hqr6lTsu74TnJjxynzibVg3Q0ZI7gD38uqp0lj0
xx4n2PC8TX+xSo5RjWrCAVEioZ7Agont4LtbehrRVOITLJrVHF6LJz3mpbX7xveJ
PuadBjWCsDBZX6N+PD6DgN0Vc6t79A==
=INDf
-----END PGP SIGNATURE-----

--L2Brqb15TUChFOBK--
