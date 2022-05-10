Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 869BB5223C4
	for <lists+live-patching@lfdr.de>; Tue, 10 May 2022 20:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243136AbiEJSWN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 May 2022 14:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242339AbiEJSWM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 May 2022 14:22:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086C82E698;
        Tue, 10 May 2022 11:18:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E3B3619FF;
        Tue, 10 May 2022 18:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F5AC385A6;
        Tue, 10 May 2022 18:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652206693;
        bh=GnNlNIZmBiwYaKqtWvRkVWbmJAdWNrKhJdlPyL34d1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lcC3CjszU6jkvzrWqklZ9QjD2qi/9xAbnvN11w382BECCG4humsY+YbvLFw2fYrD6
         I+HCJYCPNOOcln+1/m7L0pg0h8hZ6Pl4DpgEWRo2p057AidxnPZ4s6MU5LWFT6u4XK
         OfAbAoNK/bRH7lyRsyjjf8b5GNVXTa5xwyYEMC/rVEJAJYLv06+D5JOSLIEdGqNRmO
         RDgSRFvpMCgVoScxDLEiLLyMD+qNm344lk3O3hRFvNR7f0yR6LRNOu1i1dmjnnEBnr
         rbNEFrmYGVbxo821ukFLBctw/yq7PA0rPf9nhdY9V+NwM2x57gXILjUADTutqnKEJB
         twqcy1p7WqHEg==
Date:   Tue, 10 May 2022 19:18:06 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v14 2/7] arm64: Copy the task argument to unwind_state
Message-ID: <YnqsXlFO5tPtSXg4@sirena.org.uk>
References: <f460a35f88195413bcf7305e5083480aab3ca858>
 <20220413140528.3815-1-madvenka@linux.microsoft.com>
 <20220413140528.3815-3-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="VWajSRPTopwHEzEF"
Content-Disposition: inline
In-Reply-To: <20220413140528.3815-3-madvenka@linux.microsoft.com>
X-Cookie: I've read SEVEN MILLION books!!
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--VWajSRPTopwHEzEF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 13, 2022 at 09:05:23AM -0500, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> Copy the task argument passed to arch_stack_walk() to unwind_state so that
> it can be passed to unwind functions via unwind_state rather than as a
> separate argument. The task is a fundamental part of the unwind state.

Reviewed-by: Mark Brown <broonie@kernel.org>

--VWajSRPTopwHEzEF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJ6rF4ACgkQJNaLcl1U
h9CzKQf+Lyh1g6HXG5tDTSC/bkIp+/hjwCSWYpqLI1qBOEskswAebKu8NwC4At7A
PcG0G9OCacUvJy6sZJHrCxa9VSQexOSbCheYzF/lukmcUBUqDfpCW2zyg8kjZ5DJ
rzGlOMik63uR+9uW2sONrkr1rM+aeWT1Z4CbvTlxwPeBRgh12ShDhPuKKs7gafv7
2lKoPztInhEFdgiDp+N+jeFBRcgQYrTlsLVNsxTF1SUCFcHF/KLuA84C0jnUsDq2
RwYuX3zV7va+5Mu/xX3Smw6OailqnlHllm++Kl4E+7iRg2esvH/4J+uUeq57QFG1
nLfbliWZawdWtu7f+v+zSXWv/eilBw==
=tWc9
-----END PGP SIGNATURE-----

--VWajSRPTopwHEzEF--
