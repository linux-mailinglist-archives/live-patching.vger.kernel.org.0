Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D855C11413
	for <lists+live-patching@lfdr.de>; Thu,  2 May 2019 09:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfEBHWZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 May 2019 03:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbfEBHWZ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 May 2019 03:22:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D45102081C;
        Thu,  2 May 2019 07:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556781744;
        bh=CQipXRbzbW8+BqJtJPyk/Gmg8NtCxOcXlOwFdQ+0OvQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oDnxBiBT6HSRHlaWYmUFZQ08ia66Y5djWKTpd8nYmNrIfcEs8B4eN8yJes8HkPIXk
         pa1nIy3kBumIdWzIn9cYT/dcMz+SKo0UK8P4yLQxj7IxLZhHQsijFwn/2I3ALq5qlF
         oNnERViqNcC2nbHRgTAQSXHe+yr6nWBRQBIZ5gmo=
Date:   Thu, 2 May 2019 09:22:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Tobin C. Harding" <tobin@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] livepatch: Fix kobject memleak
Message-ID: <20190502072221.GA17544@kroah.com>
References: <20190502023142.20139-1-tobin@kernel.org>
 <20190502023142.20139-2-tobin@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502023142.20139-2-tobin@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, May 02, 2019 at 12:31:38PM +1000, Tobin C. Harding wrote:
> Currently error return from kobject_init_and_add() is not followed by a
> call to kobject_put().  This means there is a memory leak.
> 
> Add call to kobject_put() in error path of kobject_init_and_add().
> 
> Signed-off-by: Tobin C. Harding <tobin@kernel.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
