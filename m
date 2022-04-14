Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611D2501AA9
	for <lists+live-patching@lfdr.de>; Thu, 14 Apr 2022 20:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344292AbiDNSCq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Apr 2022 14:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344388AbiDNSCh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Apr 2022 14:02:37 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09BED1A822;
        Thu, 14 Apr 2022 11:00:04 -0700 (PDT)
Received: from leknes.fjasle.eu ([46.142.96.207]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MSss2-1nVcem2liQ-00UGG0; Thu, 14 Apr 2022 19:59:58 +0200
Received: by leknes.fjasle.eu (Postfix, from userid 1000)
        id 5D7C33C09F; Thu, 14 Apr 2022 19:59:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fjasle.eu; s=mail;
        t=1649959197; bh=VQN2S/HS4qtVdEWnDDxhVYCXlYX5FpPVZ9wVw7UD1CI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YyzfD3/C3r3kED3JZBEVqHPf5ov57h1yPUFvI2d0zNmoIKN08hSvGbUTflseCIt0/
         ourXnSTpOe5nRkKvcJjoIL6usePSe7nlPjBzgWpj6cEhKkUdWRA4eCAtf0aSTsYECY
         4kuoNtVPxAIorRy6T/TmWERHZACGwvERft23jPZU=
Date:   Thu, 14 Apr 2022 19:59:57 +0200
From:   Nicolas Schier <nicolas@fjasle.eu>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [RFC PATCH v6 02/12] kbuild: Support for symbols.klp creation
Message-ID: <YlhhHSQIWpLG0Cgn@fjasle.eu>
References: <20220216163940.228309-1-joe.lawrence@redhat.com>
 <20220216163940.228309-3-joe.lawrence@redhat.com>
 <Ylfq7t0uOP7gCPEO@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ylfq7t0uOP7gCPEO@alley>
X-Provags-ID: V03:K1:MNIlyWDKzHOK9+plu+YrD5bphyLTk8zuBAygxSnAzMDFW2MqHfj
 VwMF1T23+MBHiWf6OWJ+Lebh1b1LkVZRFrg+O+CYpoI5KVV6L++bzYifLsUWKfun9jlPXVU
 Uc3VCfX+ZakRONQb85IeuDLoLvYGdiCXvLvV/eGU0nLMmf1CX00dlPFqT5XKaVYF5t5dAHD
 k+pt1Ho9LK3d9vxB1m2pQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:6mWrdTBWKts=:kAL2IXC3yHJxQpUtCdmKMA
 vJb36zGYN0okRf1VrMX9zah3zhUHkyqj8RudPEZ8wgXhgz041f9VLF6UhRTmAY+4h8G+KUtUx
 wL7oerEoIdgk1wF5tHdkAP+2qZvSY1d/k7CLflwd2Kyey9LTC+vp50NQD5zVkidjBMtDoeft5
 csH4YZZ0Lnd/60Auu04zWPY4AKpUZrvlCS3khv6sf2BHE4tvZWT2IDsKoDtSaqHgmYxmqAKzE
 0m1YPL5Ljxe3ktLEnHEsXM6nyoMurL00bMD8szr9NzWzIyTI9XWAL9lntGqcNDhJW9DIZMOuE
 mVpLbp9gTMzKmAnexNdJ8sYN+NXld9kUUvChjMT5jHUlOLap1zkJoJHPbFFZrP2uaVooEu4VP
 XNy+btlKjZXvXBrnZ3pzR0XOys+EI8XfiHM/+7az9xWjNP8kN1vycp+28OkGJNG9VgMq5UuQz
 GE62xCbHbUrSyW0srIjrM5/E9ylHsmTogvurTkIW/lAjL2SwVA+TzSe1dUZd+Oywx6gCN4nWH
 rW6O6g9tO6mhHfIH98HzunC/ukU9epbdIekZkYEWrFRjjRwnIP1b8n4QRfiRttRhFD5XyiPgT
 Yv2ITTRAI9UOmTS/TVMpiGa/DpsnfvLNr+uRel2lzpt6fwKUiosJkLOkc8+9MK1h+UQA9spZP
 oOt9Ag/ockXigeMQXhoF5NUnBkRdxoAap//KYUk0z7ddDfzbKqIVYmNeaDSNuyVR2uaU=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_BL,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        RCVD_IN_MSPIKE_ZBI,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Apr 14, 2022 at 11:35:42AM +0200 Petr Mladek wrote:
> On Wed 2022-02-16 11:39:30, Joe Lawrence wrote:
> > From: Joao Moreira <jmoreira@suse.de>
> > 
> > For automatic resolution of livepatch relocations, a file called
> > symbols.klp is used. This file maps symbols within every compiled kernel
> > object allowing the identification of symbols whose name is unique, thus
> > relocation can be automatically inferred, or providing information that
> > helps developers when code annotation is required for solving the
> > matter.
> > 
> > Add support for creating symbols.klp in the main Makefile. First, ensure
> > that built-in is compiled when CONFIG_LIVEPATCH is enabled (as required
> > to achieve a complete symbols.klp file). Define the command to build
> > symbols.klp (cmd_klp_map) and hook it in the modules rule.
> > 
> > As it is undesirable to have symbols from livepatch objects inside
> > symbols.klp, make livepatches discernible by modifying
> > scripts/Makefile.build to create a .livepatch file for each livepatch in
> > $(MODVERDIR). This file then used by cmd_klp_map to identify and bypass
> > livepatches.
> >
> > For identifying livepatches during the build process, a flag variable
> > LIVEPATCH_$(basetarget).o is considered in scripts/Makefile.build. This
> > way, set this flag for the livepatch sample Makefile in
> > samples/livepatch/Makefile.
> 
> I do not see the related code in scripts/Makefile.build.
> 
> > Finally, Add a clean rule to ensure that symbols.klp is removed during
> > clean.
> > 
> > Notes:
> > 
> > To achieve a correct symbols.klp file, all kernel objects must be
> > considered, thus, its construction require these objects to be priorly
> > built. On the other hand, invoking scripts/Makefile.modpost without
> > having a complete symbols.klp in place would occasionally lead to
> > in-tree livepatches being post-processed incorrectly.
> 
> Honestly, I do not understand what it exactly means that "in-tree
> livepatches would occasionally be post-processed incorrectly".
> 
> Is it the problem that modpost is not able to handle the unresolved
> symbols that have to be updated by klp-convert?
> 
> > To prevent this
> > from becoming a circular dependency, the construction of symbols.klp
> > uses non-post-processed kernel objects and such does not cause harm as
> > the symbols normally referenced from within livepatches are visible at
> > this stage. Also due to these requirements, the spot in-between modules
> > compilation and the invocation of scripts/Makefile.modpost was picked
> > for hooking cmd_klp_map.
> > 
> > The approach based on .livepatch files was proposed as an alternative to
> > using MODULE_INFO statements. This approach was originally proposed by
> > Miroslav Benes as a workaround for identifying livepathes without
> > depending on modinfo during the modpost stage. It was moved to this
> > patch as the approach also shown to be useful while building
> > symbols.klp.
> 
> All the tricky code is removed in the 5th patch. My understanding is
> that the problem causing the cyclic dependency is solved by modifying
> modpost.
> 
> It looks like this patch is outdated and mostly obsoleted. On the
> other hand, the commit message in 5th patch is too short.
> 
> What about merging the two patches and updating the commit message?

+1

Yes, please merge those patches.  These '$(shell ...)' side-effect lines in the
definition of 'cmd_klp_map' are quite confusing.

Kind regards,
Nicolas
