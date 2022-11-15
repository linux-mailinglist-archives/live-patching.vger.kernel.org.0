Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9797D62A28E
	for <lists+live-patching@lfdr.de>; Tue, 15 Nov 2022 21:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbiKOUOz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Nov 2022 15:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiKOUNI (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Nov 2022 15:13:08 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440D52A97C;
        Tue, 15 Nov 2022 12:13:04 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4NBcmm2tMqz4xGH;
        Wed, 16 Nov 2022 07:12:56 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1668543179;
        bh=GLcwQC9Jey0b7v1gW6TupEgoQDbotOlF8RSjbbR1d54=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ijYmjipDyfjJii5jHIqg3BOxpP+mQU+n0YVoFAcE+i7JRhuLfwOLXPGJpX8iimsVd
         ynzUw9hJ1YG3co9qe2qdqYZ3KhlId3Urs090BCdOcj2mAVHBMsBQv8357HL7jIQhj8
         UInS7RscBiLR9FZKhIo7O+GwxidKtHkRRIc175VHX8JqYt1YFVBnAVGYbc8gp1h5yi
         PlAuhie2ZvvUCcSgEEt0ivo5QYTCDb1ZQ69ljt/EpzFoEu7wwYmICdrienrD0z0541
         gOeEXREvqbRFTVutoMywqPmsF8Lc5mkAjPzx0/xsJQawvpcVdvNY9VBFkdXLZffZo6
         nh85A7f3H082Q==
Date:   Wed, 16 Nov 2022 07:11:51 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>,
        Jiri Olsa <olsajiri@gmail.com>, nick.alcock@oracle.com,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-modules@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH v8 7/9] livepatch: Improve the search performance of
 module_kallsyms_on_each_symbol()
Message-ID: <20221116071151.3d756b1d@canb.auug.org.au>
In-Reply-To: <Y3NFoLn/GOJybXoc@bombadil.infradead.org>
References: <Y3HyrIwlZPYM8zYd@krava>
        <050b7513-4a20-75c7-0574-185004770329@huawei.com>
        <Y3IJ5GjrXBYDbfnA@krava>
        <ad637488-930e-33c1-558c-fc03d848afa8@huawei.com>
        <Y3IY6gzDtk1ze3u7@krava>
        <955eebae-0b36-d13f-0199-2f1b32af7da6@huawei.com>
        <Y3JB++KOXxMWWX35@krava>
        <Y3JivLcvbHNcIcSB@bombadil.infradead.org>
        <df46ad45-2de4-0300-4afa-5788463d712a@huawei.com>
        <Y3NADwGUIvfwnGTp@krava>
        <Y3NFoLn/GOJybXoc@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Gi/v++55E.o/dC7HkZBlTma";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

--Sig_/Gi/v++55E.o/dC7HkZBlTma
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Luis,

On Mon, 14 Nov 2022 23:54:08 -0800 Luis Chamberlain <mcgrof@kernel.org> wro=
te:
>
> Stephen, you can drop your fix from linux-next, hopefully there should
> no longer be any merge conflicts. The module requirement will stick for
> now.

OK, will do.

--=20
Cheers,
Stephen Rothwell

--Sig_/Gi/v++55E.o/dC7HkZBlTma
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmNz8ogACgkQAVBC80lX
0GxJGwf7BBsfhz9nEHmmWNZAgDzaPYbx1GDkVoywaB9VsL3hB4P7PkYM2LlhRdqC
KtKIZygES6z1csqToA1K6YMKbFz8xcBqFjFf0utVo+fBWMZN5RCjENuyB/XyIajC
7MN7TsmH02ofGzUV9SEOrxE2pUqVFzuMbdT3Q6bVTzPeTXuSMxUhTObo0vyOUgya
Mjh6Suw5PhkoMKw+pnsEjHXh35tL3ZqdTT99ggBWoXPI2caZ+/HXdE3b04S7Eyne
UpxGUs03Q1ikplAZQyuLnPI9/oM/fZgjxImpRbz79EWznK7Qb4NURGEV93/2K919
UvoYQiTV9DOTG1iyAWAZ6I9AG286NA==
=hIYn
-----END PGP SIGNATURE-----

--Sig_/Gi/v++55E.o/dC7HkZBlTma--
