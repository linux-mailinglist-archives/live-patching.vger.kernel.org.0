Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31C867C0BE
	for <lists+live-patching@lfdr.de>; Thu, 26 Jan 2023 00:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjAYXWx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 25 Jan 2023 18:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjAYXWw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 25 Jan 2023 18:22:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F7013DE4;
        Wed, 25 Jan 2023 15:22:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23798615B1;
        Wed, 25 Jan 2023 23:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E4EC433EF;
        Wed, 25 Jan 2023 23:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674688970;
        bh=FFJ0hyIrsYxFkHwnENNIexxRtW9PwQ0miSR1xoMS4Dg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WZ7cECplyCvOQ5TmV/fvsDFrh8BbuKzJlogToAgoLvGz804eaemx4AYL9jt5gG2xm
         7NEMuKIq6O1E0pv3dllYvpCNRrRGt03R/9j8mlw4/UNdBqOh352K9YBb2kTegp17GY
         O+hDrCMrmH5vglzbUt91xvCLawo1q16oLf+SNIIfHTfS/9ywSquYMatAyCunm2DY75
         ukTd6u5fZv9+gSxHzY6fEpgl45m7QwVGOxjBanW9N/JjnYjMtQZV3u/DEFM+m1XOHe
         WS8ktsxW5oJWfUxeklFrb1FyCBt4KwZJYSPDjNdlsme27epAn0+W5BZWZ3SbWqz/ZT
         VwA+nliHddoUA==
Date:   Wed, 25 Jan 2023 15:22:48 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Nicolai Stange <nstange@suse.de>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <20230125232248.inewq5tlpwfk3rny@treble>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
 <20221104010327.wa256pos75dczt4x@treble>
 <Y2TooogxxLTIkBcj@alley>
 <878rkhyhhv.fsf@linux.fritz.box>
 <Y24cGpeO8UHeiKGl@alley>
 <20221113185138.oob2o3sevbgud5vs@treble>
 <Y8a4ZQ0sm5AOnY7R@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y8a4ZQ0sm5AOnY7R@alley>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jan 17, 2023 at 04:01:57PM +0100, Petr Mladek wrote:
> IMHO, this is the reason why we should make it per-object.
> 
> If the shadow variable was used by a livepatched module and we remove
> this module then the shadow variables would get unmaintained. It would
> results in the problem described in this paragraph.

Yes, that makes sense.  Ok, I'm convinced.

BTW, this is yet another unfortunate consequence of our decision many
years ago to break the module dependency between a livepatch module and
the modules it patches.  We already have a lot of technical debt as a
result of that decision and it continues to pile up.

In that vein see also Song's and my recent patches to fix module
re-patching.

-- 
Josh
