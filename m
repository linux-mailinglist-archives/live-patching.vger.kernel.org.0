Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515F6675B47
	for <lists+live-patching@lfdr.de>; Fri, 20 Jan 2023 18:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjATR23 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 20 Jan 2023 12:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjATR22 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 20 Jan 2023 12:28:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3FF8A0FE;
        Fri, 20 Jan 2023 09:28:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DFB2B82956;
        Fri, 20 Jan 2023 17:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB549C433D2;
        Fri, 20 Jan 2023 17:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674235705;
        bh=KAwE/FbwltwelgI8ONmnO6hv7GIwu9KbDHQvOnKG9yg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=syEBgnBtc8TijH398EU1BxYRtoKotdwdRfc1YGS0xJlWNFcb6WlLSE+FBVcQjp99t
         nMaeYglkBsAlu7umSsNEIJlyTyenBCbICIKh6HoykH4McvlT0KMes3oXX+51I7Ba/E
         3U2B9+vDjcB4Xm+NPmVy13ZthwLAyS3N4C4vhuGAjbUphQigg2MRmnxl3PowFcDbTj
         CMU8a9tTCb9HSJFPHB8TsJKamPTjB5bP4h0JjmGOyXoqStdHUFfgPZye0SV/wzIb3M
         HKf/b4yjIa0ARBJ3LqHB7eN3oW/yN7DTiv8MGI2Z9Vzw1W5G9TxWVNSDagPFBpHNJZ
         qgmf6y/CaZdBQ==
Date:   Fri, 20 Jan 2023 09:28:22 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, x86@kernel.org, jikos@kernel.org,
        pmladek@suse.com, joe.lawrence@redhat.com,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v9] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20230120172822.43lreggioj7hozke@treble>
References: <20230118204728.1876249-1-song@kernel.org>
 <20230118220812.dvztwhlmliypefha@treble>
 <CAPhsuW6FyHLeG3XMMMJiNnhwzW3dPXKrj3ksyB-C_iK1PNk71Q@mail.gmail.com>
 <20230120064215.cdyfbjlas5noxam6@treble>
 <CAPhsuW75hr5kp85X3C45u071PyUHQ8NG0dnOajTc9O976wN0vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPhsuW75hr5kp85X3C45u071PyUHQ8NG0dnOajTc9O976wN0vg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jan 20, 2023 at 09:03:55AM -0800, Song Liu wrote:
> > > > Shouldn't there also be a fix for this powerpc issue?
> > >
> > > There was a working version, but it was not very clean. We couldn't agree
> > > on the path forward for powerpc, so we are hoping to ship the fix to x86 (and
> > > s390?) first [1].
> >
> > Sorry for coming in late, I was on leave so I missed a lot of the
> > discussions on previous versions.  The decision to leave powerpc broken
> > wasn't clear from reading the commit message.  The bug is mentioned, and
> > the fix is implied, but surprisingly there's no fix.
> >
> > I agree that the powerpc fix should be in a separate patch, but I still
> > don't feel comfortable merging the x86 fix without the corresponding
> > powerpc fix.
> >
> > powerpc is a major arch and not a second-class citizen.  If we don't fix
> > it now then it'll probably never get fixed until it blows up in the real
> > world.
> >
> > For powerpc, instead of clearing, how about just "fixing" the warning
> > site, something like so (untested)?
> 
> This version looks reasonable to me.

Ok, I'll run it through testing and work up a proper patch.  I just
noticed the one I posted has a major bug thanks to restore_r2()'s
surprising return semantics.

-- 
Josh
