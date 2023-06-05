Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D578B72292C
	for <lists+live-patching@lfdr.de>; Mon,  5 Jun 2023 16:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbjFEOrq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 5 Jun 2023 10:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232467AbjFEOrp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 5 Jun 2023 10:47:45 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C56E8;
        Mon,  5 Jun 2023 07:47:44 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D2B15211BD;
        Mon,  5 Jun 2023 14:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1685976462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uT1WkecRwVR0heklw85yI1h5DNfPEUrQ+mEtcnQ/ogQ=;
        b=V5LH1C5p4b+MtNSVQ+lWWLrQ86YV7jrslOqoOJFQa9oPDly7+0XYOGxGKEeGRIAhsd+qA3
        enr4+GeQGVdk7BwZmbf2WM7BHTbtcAb9pjc3T48rxBqTKf8OzxfW9kDkl283o4d7VKy10e
        /h3eUzyjzYPZ5kLzrPfxuuzdGdorpPs=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A7AFE2C141;
        Mon,  5 Jun 2023 14:47:42 +0000 (UTC)
Date:   Mon, 5 Jun 2023 16:47:42 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] livepatch: Make 'klp_stack_entries' static
Message-ID: <ZH31jrgD0i1k7n5_@alley>
References: <5115752fca6537720700f4bf5b178959dfbca41a.1685488550.git.jpoimboe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5115752fca6537720700f4bf5b178959dfbca41a.1685488550.git.jpoimboe@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2023-05-30 16:15:58, Josh Poimboeuf wrote:
> The 'klp_stack_entries' percpu array is only used in transition.c.  Make
> it static.
> 
> Fixes: e92606fa172f ("livepatch: Convert stack entries array to percpu")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202305171329.i0UQ4TJa-lkp@intel.com/
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

JFYI, the patch has been committed into livepatching.git, branch
for-6.5/core.

Best Regards,
Petr
