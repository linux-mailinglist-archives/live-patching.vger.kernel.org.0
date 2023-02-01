Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF4A685C13
	for <lists+live-patching@lfdr.de>; Wed,  1 Feb 2023 01:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbjBAASa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 31 Jan 2023 19:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbjBAAS2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 31 Jan 2023 19:18:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCFD113C6;
        Tue, 31 Jan 2023 16:18:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 44F5DCE2214;
        Wed,  1 Feb 2023 00:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAE0C433EF;
        Wed,  1 Feb 2023 00:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675210699;
        bh=Yc82FwJ1T9bu4nMSy4ctzkl+sTBfDE/2GnAQeKwi4Hg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EzG7N4FnLhc6NiG9K386pTloOQMyd98Rmj9ftqJSuFgXGwe4eoRjuRGL6tBh6Yr96
         pL+7oDBnSso451HV9H9u5G3UhgjpwDKs2zndnOy5iW13VkDPWiOetAtROy/f2lp5u3
         9tG6TmZvADFCRfFxK/C41GhBjPYrJ8lWw4nvilPWpjFVx/mZ4xo09UnTgh+ufnes2Y
         zjuzp6CRAPeLDa+qd4Y8AgvAlYiMwL6Tm2PdS9gqp8XJqdK2beJvAV3bkFBcptyRgK
         1VMPPZUBBo74ej5uFKlDpz5OUXWe86qp7zFphcQ9ie9mDdaXyys78thdF4jGc9b3ou
         nqO3qSZd5wdxQ==
Date:   Tue, 31 Jan 2023 16:18:17 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Marcos Paulo de Souza <mpdesouza@suse.com>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com, pmladek@suse.com
Subject: Re: [PATCH v2 4/4] livepatch/shadow: Add garbage collection of
 shadow variables
Message-ID: <20230201001817.ej7n3ehtgaxwr3pq@treble>
References: <20221026194122.11761-1-mpdesouza@suse.com>
 <20221026194122.11761-5-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221026194122.11761-5-mpdesouza@suse.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Oct 26, 2022 at 04:41:22PM -0300, Marcos Paulo de Souza wrote:
> The shadow variable type might then be added into a new @shadow_types
> member of struct klp_object. They will get then automatically registered
> and unregistered when the object is being livepatched. The registration
> increments the reference count. Unregistration decreases the reference
> count. All shadow variables of the given type are freed when the reference
> count reaches zero.

How does the automatic unregistration work for replaced patches?

I see klp_unpatch_replaced_patches() is called, but I don't see where it
ends up calling klp_shadow_unregister() for the replaced patch(es).

-- 
Josh
