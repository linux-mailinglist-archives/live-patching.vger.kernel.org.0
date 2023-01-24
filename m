Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837726797EA
	for <lists+live-patching@lfdr.de>; Tue, 24 Jan 2023 13:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbjAXMZm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 Jan 2023 07:25:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbjAXMZg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 Jan 2023 07:25:36 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8908218D;
        Tue, 24 Jan 2023 04:25:01 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 959BF21885;
        Tue, 24 Jan 2023 12:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674563088; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7L+ZiagwQHQdtRt6vXtjD37d8D8vBQ4zWl5QHhUF3rQ=;
        b=ZIdlLfcggbOeqcEYZbPJDQG9F/d5QnGLWF/HQ85vsbd84bp3GdxyOIMdXpj/HdMntgxDOG
        PCFGu7bFtLEIyx2ZSw3SHFGIy6IJjUxDkZ149lRq6sE4+gOQ2RjC/mkUwXrMYmxzxW4TfU
        l6/qlcM3kym925Omo2pDuXO2jNfsAmw=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 751512C141;
        Tue, 24 Jan 2023 12:24:48 +0000 (UTC)
Date:   Tue, 24 Jan 2023 13:24:48 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v10 1/2] x86/module: remove unused code in
 __apply_relocate_add
Message-ID: <Y8/OENXMkTQ3RI4z@alley>
References: <20230121004945.697003-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230121004945.697003-1-song@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2023-01-20 16:49:44, Song Liu wrote:
> This "#if 0" block has been untouched for many years. Remove it to clean
> up the code.
> 
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Song Liu <song@kernel.org>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
