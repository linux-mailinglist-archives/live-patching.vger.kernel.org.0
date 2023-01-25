Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4267967BA1C
	for <lists+live-patching@lfdr.de>; Wed, 25 Jan 2023 20:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235932AbjAYTDY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 25 Jan 2023 14:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjAYTDX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 25 Jan 2023 14:03:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEB518176;
        Wed, 25 Jan 2023 11:03:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F0DF615AF;
        Wed, 25 Jan 2023 19:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45780C433EF;
        Wed, 25 Jan 2023 19:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674673402;
        bh=XBvXsCE3HhImXaMICpwcUFklSobuJG9lBj0Wwd0QB0Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ek9Kxl3vsOdfcOeUXpZosFyFYvkVFaGxBzVHulds/XuV5HnY2Ty3xQ9zAACMRPWNO
         R/c5L+S1szy3/PLR8dttOuSjKv3i4hsWb/D2hDwJXJTv30j2hM6tzEMBOgE3DEYVow
         roZPoEkO7YRjp3Mnrpu73CRTRaZ3GuDTN5U/GlHYPhAmkssXy6WWGxfOmFu4bYTXeH
         C8h5r6/mimmqYDgdVJKIMkgnWnkmns6Q0kp8h6VxKHAqegbOifVSleGQVirpOelLrl
         QCdITNBibfxwagIanW8pYrKBjOuvHKCMEk13Y85XoAvlxjbz15yhKUDZikLPw2/q5q
         0vXMbNYDKDfKw==
Date:   Wed, 25 Jan 2023 11:03:20 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v11 1/2] x86/module: remove unused code in
 __apply_relocate_add
Message-ID: <20230125190320.dbm4q5q4lwcg5jfr@treble>
References: <20230125185401.279042-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230125185401.279042-1-song@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 25, 2023 at 10:54:00AM -0800, Song Liu wrote:
> This "#if 0" block has been untouched for many years. Remove it to clean
> up the code.
> 
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Song Liu <song@kernel.org>
> Reviewed-by: Petr Mladek <pmladek@suse.com>

Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>

-- 
Josh
