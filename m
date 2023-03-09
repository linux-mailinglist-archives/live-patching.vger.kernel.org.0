Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7744F6B21DD
	for <lists+live-patching@lfdr.de>; Thu,  9 Mar 2023 11:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjCIKwa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 Mar 2023 05:52:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjCIKw3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 Mar 2023 05:52:29 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC059E6FFB;
        Thu,  9 Mar 2023 02:52:26 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1D32321E4E;
        Thu,  9 Mar 2023 10:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678359145; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=py3v23k5lBm2min2Hx1rcN6D3GgCinn1Kv4TN5q1Kpc=;
        b=UTqglCapLF9xzfpE+c9cGNEhd2rsqS6MTrORlfhkGt4Q1DmM0LH6n+0qN5dZ3coU+5wSt1
        en6rws4ouyYMHj4T1/wMU9bsBGYJyHhapZLkxaJQF1dd8tBhOY+ITcblH04gqO2ASe1UWP
        XOJr3kpPlUuuFd+i1HRvfutamRDD3C0=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 2F5642C142;
        Thu,  9 Mar 2023 10:52:21 +0000 (UTC)
Date:   Thu, 9 Mar 2023 11:52:23 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: Make kobj_type structures constant
Message-ID: <ZAm6Z7hML4Pwp/Mp@alley>
References: <20230217-kobj_type-livepatch-v1-1-06ded292e897@weissschuh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230217-kobj_type-livepatch-v1-1-06ded292e897@weissschuh.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2023-02-17 03:14:41, Thomas Weiﬂschuh wrote:
> Since commit ee6d3dd4ed48 ("driver core: make kobj_type constant.")
> the driver core allows the usage of const struct kobj_type.
> 
> Take advantage of this to constify the structure definitions to prevent
> modification at runtime.
> 
> Signed-off-by: Thomas Weiﬂschuh <linux@weissschuh.net>

JFYI, the patch has been comitted into livepatching.git,
branch for-6.4/core.

Best Regards,
Petr
