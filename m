Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C5F475428
	for <lists+live-patching@lfdr.de>; Wed, 15 Dec 2021 09:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240764AbhLOIUD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Dec 2021 03:20:03 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:58576 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235661AbhLOIUD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Dec 2021 03:20:03 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id DF00221114;
        Wed, 15 Dec 2021 08:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639556401; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f7VLnKhrVUUur0oodep6vRHSti5c+9Tsb/5dgl6M3hk=;
        b=HVYCAsrQ21xnlrVpHD9QIONxVLtrBRPW0uWsxZcSfF5cXESGLXgPnloNKg2jemTNHWF5Z7
        82sVfLkWe5YE3w5mglTITIVomOkyvLgNKMtssHcdIkab2nDz9D33CBuE9RW8fBFXlrjBo+
        JXopZIy3BblvsI6tMl5C3pTpO+ziNNs=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A9800A3B84;
        Wed, 15 Dec 2021 08:20:01 +0000 (UTC)
Date:   Wed, 15 Dec 2021 09:19:59 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     David Vernet <void@manifault.com>, Miroslav Benes <mbenes@suse.cz>,
        linux-doc@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpoimboe@redhat.com,
        jikos@kernel.org, joe.lawrence@redhat.com, corbet@lwn.net,
        yhs@fb.com, songliubraving@fb.com
Subject: Re: [PATCH] livepatch: Fix leak on klp_init_patch_early failure path
Message-ID: <YbmlL0ZyfSuek9OB@alley>
References: <20211213191734.3238783-1-void@manifault.com>
 <YbhZwVocHDX9ZBAc@alley>
 <alpine.LSU.2.21.2112141012090.20187@pobox.suse.cz>
 <Ybi3qcA5ySDYpyib@dev0025.ash9.facebook.com>
 <Ybi9NzbvWU7ka8m1@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ybi9NzbvWU7ka8m1@kroah.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2021-12-14 16:50:15, Greg Kroah-Hartman wrote:
> 
> kobject_init() does allocate things internally, where does it say it
> does not?  What is trying to be "fixed" here?

Could you please show where things are allocated in kobject_init()?
I do not see it in the code!

It looks to me like a cargo cult claim to me.

Documentation/core-api/kobject.rst says:

   Once you registered your kobject via kobject_add(), you must never use
   kfree() to free it directly. The only safe way is to use kobject_put().

kobject_add() makes perfect sense because it copies the name, takes
reference to the parent, etc.

kobject_init() just initializes the structure members and nothing else.

Best Regards,
Petr
