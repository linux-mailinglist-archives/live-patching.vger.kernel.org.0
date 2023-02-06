Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164F768C437
	for <lists+live-patching@lfdr.de>; Mon,  6 Feb 2023 18:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbjBFRJQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Feb 2023 12:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBFRJP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Feb 2023 12:09:15 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE93D1BACF;
        Mon,  6 Feb 2023 09:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=32vtgbq8zPko9/qH1J3/ZYdeAeDZRWME+xnhuEVllJA=; b=Xh68/Bl8YWMExxK9DNKOH3Rysg
        dv0BEb/w0C5Fg+t2mkXcxRT4U+0iF1I6LE2RCiH+S5oHr87XjVzD12crGqyVVVOo1zUEuUAaBzWHY
        xpQC598R6PtoLGXZ/ZWmTFV8gVa1S7Z4lNKDRUiRqIG73YuZmNcMx6ZF9OOQw3pJbWNXornv4y105
        SWoPk5SMNUO6KWLm1NZg6Xi8RMHCiiwdO9skabmKdw3zZKBJe563gd9GhFMozrBcl3+MaMmBjAaru
        JeRIk8K64DeTAeVEmK3fhaixOadLstSzVixRChLcFe5ZaSiTFGVwBN+2Bugq5MJJ7owV8l51FNXyK
        X1cLGzOw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pP4zQ-009PeC-Vb; Mon, 06 Feb 2023 17:09:12 +0000
Date:   Mon, 6 Feb 2023 09:09:12 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Marcos Paulo de Souza <mpdesouza@suse.com>
Cc:     linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linux-doc@vger.kernel.org,
        jpoimboe@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
        corbet@lwn.net, pmladek@suse.com
Subject: Re: [PATCH v2] Document klp_modinfo using kdoc
Message-ID: <Y+E0OKpt1I5pLA8C@bombadil.infradead.org>
References: <20230203122222.1907-1-mpdesouza@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203122222.1907-1-mpdesouza@suse.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Feb 03, 2023 at 09:22:20AM -0300, Marcos Paulo de Souza wrote:
> Originally it was only one patch, but it was divided in two. The second one
> removed the local declaration to klp_modinfo and also refers to it using kdoc
> format.
> 
> Changes from v1:
> * Use kdoc (Luis)
> 
> Original commit message:
> The struct members description can be found on
> Documentation/livepatch/module-elf-format.rst, but for a developer it's
> easier to search for such information looking at the struct definition.
> 
> Marcos Paulo de Souza (2):
>   module.h: Document klp_modinfo struct using kdoc
>   Documentation: livepatch: module-elf-format: Remove local klp_modinfo
>     definition

Thanks! Merged and pushed onto modules-next! If you can get more modules
stuff into kdoc that would be appreciated!

  Luis
