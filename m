Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830BD602D66
	for <lists+live-patching@lfdr.de>; Tue, 18 Oct 2022 15:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiJRNvo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 18 Oct 2022 09:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiJRNvo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 18 Oct 2022 09:51:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D707CE9AD;
        Tue, 18 Oct 2022 06:51:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 424366159C;
        Tue, 18 Oct 2022 13:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB11C433D7;
        Tue, 18 Oct 2022 13:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666101100;
        bh=eK2npipKDmAVVE63gCk4/zWaWW/ftcfQqfBJLWTRNKI=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=CH9B7TA+QDJ1l8yBMkXm3lccvW5Z+9pXNHqING6u/exZOUHGKa00Tw6BR+E3vo+LE
         a2tsedO+ZLvs8DojI1ym0t4HAXINQx2LctcOm2vuqE+M03mcH6sLjCfQvSH7cGrp9b
         bmnFPTkHUYpnrRst/ywHMQ67Odehu7ycJFzn4aPw0rI49kDzcv9YIZw5YzGohDrdW0
         hJADxfwF5YrxMac98lzJQ3NztYi0NHW1LiyZ4Ak3MpgGRSb/1CXi8nvrn9TSB2Gohx
         EFlr+qRR2qwGS4ZxTnJn4aykBLBpq04P5H+JQtzBREXoEDzXuM+ZKuLyS9lR1DRWYt
         yra/rZsn1HNeA==
Date:   Tue, 18 Oct 2022 15:51:36 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: Move the result-invariant calculation out of
 the loop
In-Reply-To: <YzacvcSOoICzYtx8@alley>
Message-ID: <nycvar.YFH.7.76.2210181551140.29912@cbobk.fhfr.pm>
References: <20220930015446.1270-1-thunder.leizhen@huawei.com> <YzacvcSOoICzYtx8@alley>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 30 Sep 2022, Petr Mladek wrote:

> > The calculation results of the variables 'func_addr' and 'func_size' are
> > not affected by the for loop and do not change due to the changes of
> > entries[i]. The performance can be improved by moving it outside the loop.
> > 
> > No functional change.
> > 
> > Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> 
> Makes sense:
> 
> Reviewed-by: Petr Mladek <pmladek@suse.com>

Seems like this wasn't picked up by anybody, so I have now pushed it to 
livepatching.git#for-6.2/core

Thanks,

-- 
Jiri Kosina
SUSE Labs

