Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46125532BFD
	for <lists+live-patching@lfdr.de>; Tue, 24 May 2022 16:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238048AbiEXOKC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 May 2022 10:10:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiEXOKA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 May 2022 10:10:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745B622BD9;
        Tue, 24 May 2022 07:09:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C35CB818F8;
        Tue, 24 May 2022 14:09:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23EDFC385AA;
        Tue, 24 May 2022 14:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653401396;
        bh=JSvnpXphnJVhQGLmr4fRzu2m32BHhsihRMGPZ44KA/0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pxv/k92VTewMWk1kEI3FhNrWFC+/fjrBwAr6w2jhhvYpFmn1xHQx36moo5NORa/Qa
         mSx9qx1yw/VoprUhnfCHuzpfBR4uNnGbWKefyOQtjRpTi/eC3z/q7eM5whgrFne+tz
         DLv5fwgLRMZlCdxZJm7mStTZa5zNxnDe6ZxPpC2HI1HzOW3qXptQkQWemtSokkyj4B
         C4zCbsFdAj60aWqcJP8Upvsug9yh6K4yDU9J5+FFAgvulN34YO3TnYXUCAOFBP3+3P
         njyoAu1jivnufeNgrDf39SIkrpvYUVgAfl+i4A0qKUra0mQW175RfczXJrNKWo4O+U
         I1N2xAbQEE8FA==
Date:   Tue, 24 May 2022 15:09:49 +0100
From:   Mark Brown <broonie@kernel.org>
To:     madvenka@linux.microsoft.com
Cc:     jpoimboe@redhat.com, peterz@infradead.org, chenzhongjin@huawei.com,
        mark.rutland@arm.com, nobuta.keiya@fujitsu.com,
        sjitindarsingh@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 09/20] objtool: arm64: Implement command to invoke
 the decoder
Message-ID: <YoznLR30T+03Ea08@sirena.org.uk>
References: <e81e773678f88f7c2ff7480e2eb096973ec198db>
 <20220524001637.1707472-1-madvenka@linux.microsoft.com>
 <20220524001637.1707472-10-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="XOjh9GBsKRkCZwof"
Content-Disposition: inline
In-Reply-To: <20220524001637.1707472-10-madvenka@linux.microsoft.com>
X-Cookie: A man's best friend is his dogma.
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


--XOjh9GBsKRkCZwof
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 23, 2022 at 07:16:26PM -0500, madvenka@linux.microsoft.com wrot=
e:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>=20
> Implement a built-in command called cmd_fpv() that can be invoked as
> follows:
>=20
> 	objtool fpv generate file.o
>=20
> The built-in command invokes decode_instructions() to walk each function
> and decode the instructions of the function.

In commit b51277eb9775ce91 ("objtool: Ditch subcommands") Josh removed
subcommands so this interface is going to need a rethink.

--XOjh9GBsKRkCZwof
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKM5y0ACgkQJNaLcl1U
h9BLywf8DgDILXDJ1Omp3W4aQd53XxP43eT/TCF/QNejM1EVAPhUHwuRYgkvHZgG
bICv+JnXHRCGs1okzLhhCnfBbLYzF5pe5IOO6Pd8hX42JXryThS0S30ozNfiAD4Z
2fqxPwbDWbLSuA+DT7rHUpI3ejB+yKlErsuDyUDwIEnOOQdK/jf+TnX6/xhrkS7L
ei584kKqsXgq8sXLC2A8DS3Bw2bUXdnWrFf1+tKjztt4LSylTe9pJij1AsouZLlV
CRj2yNRMvjz7ybRyd9IFJFE8EKMfuYoX0Q2nOLlNEn1+8JYqPRWZdDHwhfPDwIOa
itEUQIjjN8Dtlr6Xl5lk+3+W4U3mKg==
=Xi99
-----END PGP SIGNATURE-----

--XOjh9GBsKRkCZwof--
