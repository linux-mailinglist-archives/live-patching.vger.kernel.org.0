Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDDB722CD6
	for <lists+live-patching@lfdr.de>; Mon,  5 Jun 2023 18:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbjFEQjk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 5 Jun 2023 12:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjFEQjj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 5 Jun 2023 12:39:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE549FA
        for <live-patching@vger.kernel.org>; Mon,  5 Jun 2023 09:39:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BE9F618DC
        for <live-patching@vger.kernel.org>; Mon,  5 Jun 2023 16:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839F3C433D2;
        Mon,  5 Jun 2023 16:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685983176;
        bh=iZWMe3FUix/iValzRwJZJcHnZMQIXyaYgI/w4cDZe/M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T8ixW+02usrGpOA5QG2wMWyOlc9O2acidtU0pjN+pdedwtxsNCGnmPyCgv4wfWZUT
         9K2txMOGZwW2GZdLBny/RWIhGgSaEFUGoCWsj7rfyageZ5tNZVo6j0R1FZdzlzZb71
         yXvDcBYgZjhda2+R6Gu4ixBvZG712j85iKUmOtyBAqvCTO6UoixKShmllC9xs7O/jz
         lpgzY4grwTirCf7HeRv1vxU9JuxJnyaE00y0BIP6uxKY8eUpxVt63bVi/+dWzwh0RB
         9u/uqgeH/KQcwnCeSPdJcm6FpkTI6daYuttp5QKHRoDPZUqcRZx6jIwjJnXmnCJRxF
         VKFtm+nNtcyrg==
Date:   Mon, 5 Jun 2023 09:39:34 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, joe.lawrence@redhat.com, kernel-team@meta.com
Subject: Re: [PATCH] livepatch: match symbols exactly in
 klp_find_object_symbol()
Message-ID: <20230605163934.sgowjnvpyqzcxamj@treble>
References: <20230602232401.3938285-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230602232401.3938285-1-song@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jun 02, 2023 at 04:24:01PM -0700, Song Liu wrote:
> With CONFIG_LTO_CLANG, kallsyms.c:cleanup_symbol_name() removes symbols
> suffixes during comparison. This is problematic for livepatch, as
> kallsyms_on_each_match_symbol may find multiple matches for the same
> symbol, and fail with:
> 
>   livepatch: unresolvable ambiguity for symbol 'xxx' in object 'yyy'
> 
> Fix this by using kallsyms_on_each_symbol instead, and matching symbols
> exactly.
> 
> Signed-off-by: Song Liu <song@kernel.org>

Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>

-- 
Josh
